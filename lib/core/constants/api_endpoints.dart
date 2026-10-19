/// REST paths, relative to the API base URL (Dio's `baseUrl`).
///
/// Only paths documented in the brief are listed. Sign-in, sign-out and the
/// write endpoints (assign, cancel, refund, acknowledge, user management)
/// are added from `/docs` with the milestone that uses them.
abstract final class ApiEndpoints {
  /// Signed-in user with role, city and permissions.
  static const me = '/api/me';

  /// `200 { ok: true }` when up, `503 { maintenance: true, … }` otherwise.
  static const health = '/api/health';
}
