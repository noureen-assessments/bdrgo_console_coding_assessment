import 'dart:async';

import 'package:badrgo_console_assesment/core/errors/failures.dart';
import 'package:badrgo_console_assesment/features/auth/domain/entities/current_user.dart';
import 'package:badrgo_console_assesment/features/auth/domain/usecases/restore_session_use_case.dart';
import 'package:badrgo_console_assesment/features/auth/domain/usecases/sign_out_use_case.dart';
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

void main() {
  late _MockRestore restore;
  late _MockSignOut signOut;
  late _MockWatchExpiry watchExpiry;
  late StreamController<void> expired;

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    restore = _MockRestore();
    signOut = _MockSignOut();
    watchExpiry = _MockWatchExpiry();
    expired = StreamController<void>.broadcast();
    when(() => watchExpiry(any())).thenAnswer((_) => expired.stream);
  });

  AuthBloc build() => AuthBloc(
    restoreSession: restore,
    signOut: signOut,
    watchSessionExpiry: watchExpiry,
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

    await bloc.close();

    expect(expired.hasListener, isFalse);
  });
}
