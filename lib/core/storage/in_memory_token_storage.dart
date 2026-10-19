import 'token_storage.dart';

/// Web cookie mode: the token is never written to localStorage,
/// sessionStorage or IndexedDB.
///
/// The persistent credential is the server's `HttpOnly` cookie, which
/// JavaScript cannot read and the browser sends on its own. The token kept
/// here only covers the current page, for the `?token=` that SSE and
/// WebSocket need. A refresh clears it and the session is restored from the
/// cookie.
final class InMemoryTokenStorage implements TokenStorage {
  String? _token;

  @override
  Future<String?> getToken() async => _token;

  @override
  Future<void> saveToken(String token) async {
    if (token.isNotEmpty) _token = token;
  }

  @override
  Future<void> deleteToken() async => _token = null;
}
