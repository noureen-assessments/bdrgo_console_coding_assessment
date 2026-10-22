import 'package:badrgo_console_assesment/core/errors/failures.dart';
import 'package:badrgo_console_assesment/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:badrgo_console_assesment/features/auth/presentation/bloc/sign_in/sign_in_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../auth_fixtures.dart';

class _MockSignIn extends Mock implements SignInUseCase {}

void main() {
  late _MockSignIn signIn;
  const submit = SignInSubmitted(email: 'a@b.c', password: 'secret');

  setUpAll(
    () => registerFallbackValue(const SignInParams(email: '', password: '')),
  );

  setUp(() {
    signIn = _MockSignIn();
  });

  SignInBloc build() => SignInBloc(signIn: signIn);

  blocTest<SignInBloc, SignInState>(
    'succeeds with the signed-in user',
    setUp: () => when(
      () => signIn(any()),
    ).thenAnswer((_) async => const Right(dispatcher)),
    build: build,
    act: (bloc) => bloc.add(submit),
    expect: () => [const SignInInProgress(), const SignInSucceeded(dispatcher)],
  );

  blocTest<SignInBloc, SignInState>(
    "shows the server's message (wrong password, banned user)",
    setUp: () => when(() => signIn(any())).thenAnswer(
      (_) async => const Left(ServerFailure('You have been banned')),
    ),
    build: build,
    act: (bloc) => bloc.add(submit),
    expect: () => [
      const SignInInProgress(),
      const SignInFailed('You have been banned'),
    ],
  );

  blocTest<SignInBloc, SignInState>(
    'offline shows the connection error',
    setUp: () => when(
      () => signIn(any()),
    ).thenAnswer((_) async => const Left(NetworkFailure('offline'))),
    build: build,
    act: (bloc) => bloc.add(submit),
    expect: () => [const SignInInProgress(), const SignInFailed('offline')],
  );
}
