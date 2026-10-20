import 'package:flutter/foundation.dart';

enum WebAuthMode {
  cookie,

  storage,
}

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

  static String get apiUrl {
    if (_apiUrl.isEmpty) throw StateError(missingApiUrl);
    return _apiUrl;
  }

  static WebAuthMode get webAuthMode => parseWebAuthMode(_webAuthMode);

  static bool get usesHttpOnlyCookie =>
      kIsWeb && webAuthMode == WebAuthMode.cookie;

  @visibleForTesting
  static WebAuthMode parseWebAuthMode(String value) {
    if (value.isEmpty) return WebAuthMode.storage;
    final mode = WebAuthMode.values.asNameMap()[value];
    if (mode == null) throw StateError(invalidWebAuthMode);
    return mode;
  }
}
