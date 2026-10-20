part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

final class SignInIdle extends SignInState {
  const SignInIdle();
}

final class SignInInProgress extends SignInState {
  const SignInInProgress();
}

final class SignInFailed extends SignInState {
  const SignInFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class SignInSucceeded extends SignInState {
  const SignInSucceeded(this.user);

  final CurrentUser user;

  @override
  List<Object?> get props => [user];
}
