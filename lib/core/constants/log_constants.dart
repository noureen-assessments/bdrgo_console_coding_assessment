/// Logger names, shown as the source of each line in DevTools.
abstract final class LogTags {
  static const app = 'app';
  static const bloc = 'bloc';
  static const http = 'http';
  static const storage = 'storage';
}

/// Log lines. Never include tokens, passwords or request bodies.
abstract final class LogMessages {
  static const emptyToken = 'Token value is empty';
  static const secureStorageFailed = 'Secure storage failed';
  static const redacted = '[REDACTED]';
  static const redactedPath = '/[REDACTED_PATH]/';

  static String redactedFrame(String? file) => '$redactedPath$file:';

  static String blocEvent(Object bloc, Object? event) =>
      '${bloc.runtimeType} <- ${event.runtimeType}';

  static String blocFailed(Object bloc) => '${bloc.runtimeType} failed';

  static String httpRequest(String method, Uri uri) => '-> $method $uri';

  static String failure(Object type, int? status, String message) =>
      '$type($status): $message';

  static String httpResponse(Object? status, Uri uri) => '<- $status $uri';
}

/// Patterns masked before an error reaches logs or crash reports.
abstract final class SensitiveDataPatterns {
  static final jwt = RegExp(r'eyJ[\w-]*\.[\w-]*\.[\w-]*');
  static final opaqueToken = RegExp(r'[A-Za-z0-9]{32,}');
  static final cardNumber = RegExp(r'\b\d{12,19}\b');
  static final email = RegExp(r'[\w.-]+@[\w.-]+\.\w+');

  /// JWTs first, so a token is masked whole rather than piece by piece.
  static final inErrors = List<RegExp>.unmodifiable([
    jwt,
    opaqueToken,
    cardNumber,
    email,
  ]);

  /// Directory part of a stack-trace frame; group 1 is the file name.
  static final filePath = RegExp(r'\/.*\/(.*):');
}
