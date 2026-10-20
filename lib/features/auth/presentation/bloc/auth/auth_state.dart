part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthRestoring extends AuthState {
  const AuthRestoring();
}

final class AuthRestoreFailed extends AuthState {
  const AuthRestoreFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(
    this.user, {
    this.isSigningOut = false,
    this.signOutError,
  });

  final CurrentUser user;
  final bool isSigningOut;

  final String? signOutError;

  @override
  List<Object?> get props => [user, isSigningOut, signOutError];
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.sessionExpired = false});

  final bool sessionExpired;

  @override
  List<Object?> get props => [sessionExpired];
}
