/// Persists the session token. The interceptor, SSE and WebSocket clients
/// depend on this interface, not on a storage package.
abstract interface class TokenStorage {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> deleteToken();
}
