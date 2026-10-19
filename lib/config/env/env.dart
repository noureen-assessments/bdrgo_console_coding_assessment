import 'package:flutter/foundation.dart';

/// How the web build keeps the session. Mobile always uses the platform's
/// secure storage.
enum WebAuthMode {
  /// The server's `HttpOnly` cookie is the credential; requests are sent
  /// with credentials and the token lives in memory only.
  cookie,

  /// Fallback when the API does not issue cookies: the token is encrypted
  /// in sessionStorage via flutter_secure_storage.
  storage,
}

/// Build-time values passed with `--dart-define`. No URL or secret is
/// hard-coded: the API URL must be passed at build time.
abstract final class Env {
  static const apiUrlKey = 'API_URL';
  static const missingApiUrl =
      '$apiUrlKey is not set. Run with --dart-define=$apiUrlKey=https://…';
  static const invalidApiUrl = 'Must be an http(s) URL';

  static const webAuthModeKey = 'WEB_AUTH_MODE';
  static const invalidWebAuthMode =
      '$webAuthModeKey must be one of: cookie, storage';

  static const _apiUrl = String.fromEnvironment(apiUrlKey);
  static const _webAuthMode = String.fromEnvironment(webAuthModeKey);

  /// The `API_URL` define. Throws at startup when it is missing, so a build
  /// can never silently talk to the wrong server.
  static String get apiUrl {
    if (_apiUrl.isEmpty) throw StateError(missingApiUrl);
    return _apiUrl;
  }

  /// The `WEB_AUTH_MODE` define; [WebAuthMode.cookie] when not passed.
  static WebAuthMode get webAuthMode => parseWebAuthMode(_webAuthMode);

  /// True on web in cookie mode: send credentials, keep nothing in storage.
  static bool get usesHttpOnlyCookie =>
      kIsWeb && webAuthMode == WebAuthMode.cookie;

  @visibleForTesting
  static WebAuthMode parseWebAuthMode(String value) {
    if (value.isEmpty) return WebAuthMode.cookie;
    final mode = WebAuthMode.values.asNameMap()[value];
    if (mode == null) throw StateError(invalidWebAuthMode);
    return mode;
  }
}
