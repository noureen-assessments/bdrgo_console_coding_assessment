part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Checking the stored session on start-up.
final class AuthRestoring extends AuthState {
  const AuthRestoring();
}

/// The session could not be checked (offline, maintenance, server error).
/// The token is kept: this is not a sign-out.
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

  /// Set when the server could not revoke the token; the user stays signed
  /// in so they can try again.
  final String? signOutError;

  @override
  List<Object?> get props => [user, isSigningOut, signOutError];
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.sessionExpired = false});

  /// True when the server ended the session (token expired or revoked, user
  /// banned), so the sign-in page can say why.
  final bool sessionExpired;

  @override
  List<Object?> get props => [sessionExpired];
}
