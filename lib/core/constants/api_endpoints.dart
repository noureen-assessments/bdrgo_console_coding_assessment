/// REST paths, relative to the API base URL (Dio's `baseUrl`).
///
/// Write endpoints (assign, cancel, refund, acknowledge, user management)
/// are added from `/docs` with the milestone that uses them.
abstract final class ApiEndpoints {
  /// Better Auth email sign-in; returns `token` and `user`.
  static const signIn = '/api/auth/sign-in/email';

  /// Revokes the session token on the server. Expects an empty JSON body.
  static const signOut = '/api/auth/sign-out';

  /// Signed-in user with role, city and permissions.
  static const me = '/api/me';

  /// `200 { ok: true }` when up, `503 { maintenance: true, … }` otherwise.
  static const health = '/api/health';
}
