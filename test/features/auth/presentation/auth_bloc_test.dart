import 'dart:async';

import 'package:badrgo_console_assesment/core/errors/failures.dart';
import 'package:badrgo_console_assesment/features/auth/domain/entities/current_user.dart';
import 'package:badrgo_console_assesment/features/auth/domain/entities/permission.dart';
import 'package:badrgo_console_assesment/features/auth/domain/entities/permissions.dart';
import 'package:badrgo_console_assesment/features/auth/domain/entities/user_role.dart';
import 'package:badrgo_console_assesment/features/auth/domain/usecases/restore_session_use_case.dart';
import 'package:badrgo_console_assesment/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:badrgo_console_assesment/features/auth/domain/usecases/watch_access_denied_use_case.dart';
import 'package:badrgo_console_assesment/features/auth/domain/usecases/watch_session_expiry_use_case.dart';
import 'package:badrgo_console_assesment/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:badrgo_console_assesment/shared/use_cases/use_case.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../auth_fixtures.dart';

class _MockRestore extends Mock implements RestoreSessionUseCase {}

class _MockSignOut extends Mock implements SignOutUseCase {}

class _MockWatchExpiry extends Mock implements WatchSessionExpiryUseCase {}

class _MockWatchDenied extends Mock implements WatchAccessDeniedUseCase {}

/// The dispatcher after a super_admin re-roled them to viewer.
const _reRoled = CurrentUser(
  id: 'u1',
  name: 'Dana Dispatcher',
  email: 'dispatch.doha@demo.test',
  role: UserRole.viewer,
  permissions: Permissions({TripPermission.read}),
);

void main() {
  late _MockRestore restore;
  late _MockSignOut signOut;
  late _MockWatchExpiry watchExpiry;
  late _MockWatchDenied watchDenied;
  late StreamController<void> expired;
  late StreamController<void> denied;

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    restore = _MockRestore();
    signOut = _MockSignOut();
    watchExpiry = _MockWatchExpiry();
    watchDenied = _MockWatchDenied();
    expired = StreamController<void>.broadcast();
    denied = StreamController<void>.broadcast();
    when(() => watchExpiry(any())).thenAnswer((_) => expired.stream);
    when(() => watchDenied(any())).thenAnswer((_) => denied.stream);
  });

  AuthBloc build() => AuthBloc(
    restoreSession: restore,
    signOut: signOut,
    watchSessionExpiry: watchExpiry,
    watchAccessDenied: watchDenied,
  );

  void restoreReturns(CurrentUser? result) =>
      when(() => restore(any())).thenAnswer((_) async => Right(result));

  group('start-up', () {
    blocTest<AuthBloc, AuthState>(
      'a stored session survives a refresh',
      setUp: () => restoreReturns(dispatcher),
      build: build,
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [
        const AuthRestoring(),
        const AuthAuthenticated(dispatcher),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'no session goes to sign-in',
      setUp: () => restoreReturns(null),
      build: build,
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [const AuthRestoring(), const AuthUnauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'offline fails without signing out, then retries once back online',
      setUp: () {
        var calls = 0;
        when(() => restore(any())).thenAnswer(
          (_) async => calls++ == 0
              ? const Left(NetworkFailure('offline'))
              : const Right(dispatcher),
        );
      },
      build: build,
      act: (bloc) async {
        bloc.add(const AuthStarted());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const AuthConnectionRestored());
      },
      expect: () => [
        const AuthRestoring(),
        const AuthRestoreFailed('offline'),
        const AuthRestoring(),
        const AuthAuthenticated(dispatcher),
      ],
    );
  });

  group('session expiry (any 401)', () {
    blocTest<AuthBloc, AuthState>(
      'signs out once, even for a burst of 401s, without calling the server',
      setUp: () => restoreReturns(dispatcher),
      build: build,
      act: (bloc) async {
        bloc.add(const AuthStarted());
        await Future<void>.delayed(Duration.zero);
        expired
          ..add(null)
          ..add(null)
          ..add(null);
      },
      expect: () => [
        const AuthRestoring(),
        const AuthAuthenticated(dispatcher),
        const AuthUnauthenticated(sessionExpired: true),
      ],
      verify: (_) => verifyNever(() => signOut(any())),
    );

    blocTest<AuthBloc, AuthState>(
      'is ignored when already signed out',
      setUp: () => restoreReturns(null),
      build: build,
      act: (bloc) async {
        bloc.add(const AuthStarted());
        await Future<void>.delayed(Duration.zero);
        expired.add(null);
      },
      expect: () => [const AuthRestoring(), const AuthUnauthenticated()],
    );
  });

  group('access denied (any 403)', () {
    /// Restores [dispatcher] on start, then answers [afterDenied] after a
    /// short delay, like a real request.
    void restoreThen(Either<Failure, CurrentUser?> afterDenied) {
      var calls = 0;
      when(() => restore(any())).thenAnswer((_) async {
        if (calls++ == 0) return const Right(dispatcher);
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return afterDenied;
      });
    }

    Future<void> startThenDeny(AuthBloc bloc, {int times = 1}) async {
      bloc.add(const AuthStarted());
      await Future<void>.delayed(Duration.zero);
      for (var i = 0; i < times; i++) {
        denied.add(null);
      }
    }

    blocTest<AuthBloc, AuthState>(
      'a re-roled user gets the new permissions without signing out',
      setUp: () => restoreThen(const Right(_reRoled)),
      build: build,
      act: startThenDeny,
      wait: const Duration(milliseconds: 20),
      expect: () => [
        const AuthRestoring(),
        const AuthAuthenticated(dispatcher),
        const AuthAuthenticated(_reRoled),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'a burst of 403s re-fetches the profile once',
      setUp: () => restoreThen(const Right(_reRoled)),
      build: build,
      act: (bloc) => startThenDeny(bloc, times: 3),
      wait: const Duration(milliseconds: 20),
      expect: () => [
        const AuthRestoring(),
        const AuthAuthenticated(dispatcher),
        const AuthAuthenticated(_reRoled),
      ],
      verify: (_) => verify(() => restore(any())).called(2),
    );

    blocTest<AuthBloc, AuthState>(
      'keeps the current permissions when the re-fetch fails',
      setUp: () => restoreThen(const Left(NetworkFailure('offline'))),
      build: build,
      act: startThenDeny,
      wait: const Duration(milliseconds: 20),
      expect: () => [
        const AuthRestoring(),
        const AuthAuthenticated(dispatcher),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'a session gone meanwhile goes to sign-in',
      setUp: () => restoreThen(const Right(null)),
      build: build,
      act: startThenDeny,
      wait: const Duration(milliseconds: 20),
      expect: () => [
        const AuthRestoring(),
        const AuthAuthenticated(dispatcher),
        const AuthUnauthenticated(sessionExpired: true),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'is ignored when signed out',
      setUp: () => restoreReturns(null),
      build: build,
      act: startThenDeny,
      expect: () => [const AuthRestoring(), const AuthUnauthenticated()],
      verify: (_) => verify(() => restore(any())).called(1),
    );
  });

  group('sign-out', () {
    blocTest<AuthBloc, AuthState>(
      'revokes on the server and goes to sign-in',
      setUp: () =>
          when(() => signOut(any())).thenAnswer((_) async => const Right(unit)),
      build: build,
      seed: () => const AuthAuthenticated(dispatcher),
      act: (bloc) => bloc.add(const AuthSignOutRequested()),
      expect: () => [
        const AuthAuthenticated(dispatcher, isSigningOut: true),
        const AuthUnauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'stays signed in with the reason when the server cannot be reached',
      setUp: () => when(
        () => signOut(any()),
      ).thenAnswer((_) async => const Left(NetworkFailure('offline'))),
      build: build,
      seed: () => const AuthAuthenticated(dispatcher),
      act: (bloc) => bloc.add(const AuthSignOutRequested()),
      expect: () => [
        const AuthAuthenticated(dispatcher, isSigningOut: true),
        const AuthAuthenticated(dispatcher, signOutError: 'offline'),
      ],
    );
  });

  test('closing the Bloc stops listening (no leaked subscriptions)', () async {
    restoreReturns(null);
    final bloc = build()..add(const AuthStarted());
    await Future<void>.delayed(Duration.zero);
    expect(expired.hasListener, isTrue);
    expect(denied.hasListener, isTrue);

    await bloc.close();

    expect(expired.hasListener, isFalse);
    expect(denied.hasListener, isFalse);
  });
}
