import 'package:badrgo_console_assesment/core/errors/failures.dart';
import 'package:badrgo_console_assesment/core/session/access_denied_notifier.dart';
import 'package:badrgo_console_assesment/core/session/session_expiry_notifier.dart';
import 'package:badrgo_console_assesment/core/storage/token_storage.dart';
import 'package:badrgo_console_assesment/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:badrgo_console_assesment/features/auth/data/models/me_model.dart';
import 'package:badrgo_console_assesment/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../auth_fixtures.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

class _MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late _MockRemote remote;
  late _MockTokenStorage tokens;
  late SessionExpiryNotifier sessionExpiry;
  late AccessDeniedNotifier accessDenied;
  late AuthRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    tokens = _MockTokenStorage();
    sessionExpiry = SessionExpiryNotifier();
    accessDenied = AccessDeniedNotifier();
    repository = AuthRepositoryImpl(
      remote: remote,
      tokenStorage: tokens,
      sessionExpiry: sessionExpiry,
      accessDenied: accessDenied,
    );
    when(() => tokens.saveToken(any())).thenAnswer((_) async {});
    when(tokens.deleteToken).thenAnswer((_) async {});
  });

  void signInReturns(String token) => when(
    () => remote.signIn(
      email: any(named: 'email'),
      password: any(named: 'password'),
    ),
  ).thenAnswer((_) async => token);

  group('signIn', () {
    test('stores the token, then loads the profile', () async {
      signInReturns('t1');
      when(remote.fetchMe).thenAnswer((_) async => MeModel.fromJson(meJson()));

      final result = await repository.signIn(email: 'a@b.c', password: 'p');

      expect(result.getRight().toNullable()?.name, 'Dana Dispatcher');
      verifyInOrder([() => tokens.saveToken('t1'), remote.fetchMe]);
    });

    test("passes the server's error through and stores nothing", () async {
      when(
        () => remote.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const ServerFailure('Invalid email or password'));

      final result = await repository.signIn(email: 'a@b.c', password: 'x');

      expect(
        result,
        const Left<Failure, Never>(ServerFailure('Invalid email or password')),
      );
      verifyNever(() => tokens.saveToken(any()));
    });

    test('drops the token when the profile cannot be loaded', () async {
      signInReturns('t1');
      when(remote.fetchMe).thenThrow(const NetworkFailure('offline'));

      final result = await repository.signIn(email: 'a@b.c', password: 'p');

      expect(result.isLeft(), isTrue);
      verify(tokens.deleteToken).called(1);
    });
  });

  group('restoreSession', () {
    test(
      'a 401 means signed out: returns null and forgets the token',
      () async {
        when(remote.fetchMe).thenThrow(const UnauthenticatedFailure('expired'));

        final result = await repository.restoreSession();

        expect(result, const Right<Failure, Null>(null));
        verify(tokens.deleteToken).called(1);
      },
    );

    test('offline keeps the token so the session survives', () async {
      when(remote.fetchMe).thenThrow(const NetworkFailure('offline'));

      final result = await repository.restoreSession();

      expect(result, const Left<Failure, Never>(NetworkFailure('offline')));
      verifyNever(tokens.deleteToken);
    });
  });

  group('signOut', () {
    test('revokes on the server, then forgets the token', () async {
      when(remote.signOut).thenAnswer((_) async {});

      final result = await repository.signOut();

      expect(result, const Right<Failure, Unit>(unit));
      verifyInOrder([remote.signOut, tokens.deleteToken]);
    });

    test('offline still forgets the token on this device', () async {
      when(remote.signOut).thenThrow(const NetworkFailure('offline'));

      final result = await repository.signOut();

      expect(result, const Right<Failure, Unit>(unit));
      verify(tokens.deleteToken).called(1);
    });

    test('an already revoked token counts as signed out', () async {
      when(remote.signOut).thenThrow(const UnauthenticatedFailure('gone'));

      final result = await repository.signOut();

      expect(result, const Right<Failure, Unit>(unit));
      verify(tokens.deleteToken).called(1);
    });
  });

  test('a 401 anywhere forgets the token, then reports the expiry', () async {
    final expiry = expectLater(repository.watchSessionExpiry(), emits(null));

    sessionExpiry.notify();
    await expiry;

    verify(tokens.deleteToken).called(1);
  });

  test('a 403 anywhere is reported and keeps the token', () async {
    final denied = expectLater(repository.watchAccessDenied(), emits(null));

    accessDenied.notify();
    await denied;

    verifyNever(tokens.deleteToken);
  });
}
