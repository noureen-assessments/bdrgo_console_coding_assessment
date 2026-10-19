part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

/// Once, on app start: checks the stored session and starts listening for
/// session expiry.
final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

/// Retry after a failed session check.
final class AuthRestoreRequested extends AuthEvent {
  const AuthRestoreRequested();
}

/// The sign-in page finished signing in.
final class AuthSignedIn extends AuthEvent {
  const AuthSignedIn(this.user);

  final CurrentUser user;
}

final class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// The browser is back online; a failed session check is tried again.
final class AuthConnectionRestored extends AuthEvent {
  const AuthConnectionRestored();
}
