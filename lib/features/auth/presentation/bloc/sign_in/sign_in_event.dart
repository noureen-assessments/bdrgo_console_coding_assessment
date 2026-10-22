part of 'sign_in_bloc.dart';

sealed class SignInEvent {
  const SignInEvent();
}

final class SignInSubmitted extends SignInEvent {
  const SignInSubmitted({required this.email, required this.password});

  final String email;
  final String password;
}
