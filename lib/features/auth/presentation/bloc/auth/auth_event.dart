part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

final class AuthRestoreRequested extends AuthEvent {
  const AuthRestoreRequested();
}

final class AuthSignedIn extends AuthEvent {
  const AuthSignedIn(this.user);

  final CurrentUser user;
}

final class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

final class AuthConnectionRestored extends AuthEvent {
  const AuthConnectionRestored();
}

final class AuthAccessDenied extends AuthEvent {
  const AuthAccessDenied();
}
