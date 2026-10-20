abstract final class LogTags {
  static const app = 'app';
  static const bloc = 'bloc';
  static const http = 'http';
  static const storage = 'storage';
  static const sse = 'sse';
}

abstract final class LogMessages {
  static const emptyToken = 'Token value is empty';
  static const secureStorageFailed = 'Secure storage failed';
  static const redacted = '[REDACTED]';
  static const redactedPath = '/[REDACTED_PATH]/';
  static const sseRefused = 'SSE connection refused; checking the session';
  static const sseBadFrame = 'SSE frame skipped: data is not a JSON object';

  static String redactedFrame(String? file) => '$redactedPath$file:';

  static String blocEvent(Object bloc, Object? event) =>
      '${bloc.runtimeType} <- ${event.runtimeType}';

  static String blocFailed(Object bloc) => '${bloc.runtimeType} failed';

  static String httpRequest(String method, Uri uri) => '-> $method $uri';

  static String failure(Object type, int? status, String message) =>
      '$type($status): $message';

  static String httpResponse(Object? status, Uri uri) => '<- $status $uri';
}

abstract final class SensitiveDataPatterns {
  static final jwt = RegExp(r'eyJ[\w-]*\.[\w-]*\.[\w-]*');
  static final opaqueToken = RegExp(r'[A-Za-z0-9]{32,}');
  static final cardNumber = RegExp(r'\b\d{12,19}\b');
  static final email = RegExp(r'[\w.-]+@[\w.-]+\.\w+');

  static final inErrors = List<RegExp>.unmodifiable([
    jwt,
    opaqueToken,
    cardNumber,
    email,
  ]);

  static final filePath = RegExp(r'\/.*\/(.*):');
}
