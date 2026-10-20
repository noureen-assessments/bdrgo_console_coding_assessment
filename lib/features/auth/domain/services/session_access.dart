import '../entities/permission.dart';

/// What code outside the auth feature (router, guards) may ask about the
/// current session. Callers depend on this interface, not on how the auth
/// feature keeps the session.
abstract interface class SessionAccess {
  bool get isSignedIn;

  /// False when signed out.
  bool can(Permission permission);
}
