/// URL building blocks shared by the transports.
abstract final class UrlConstants {
  static const http = 'http';
  static const https = 'https';
  static const ws = 'ws';
  static const wss = 'wss';
  static const schemeSeparator = '://';
  static const pathSeparator = '/';

  /// Browsers cannot set headers on `EventSource` or `WebSocket`, so those
  /// two send the token as `?token=`.
  static const tokenQueryParam = 'token';
}
