import '../constants/graphql_endpoints.dart';
import '../constants/sse_events.dart';
import '../constants/url_constants.dart';
import '../constants/websocket_events.dart';

/// Builds absolute URLs for every transport from one base URL, so the app
/// can be pointed at any environment with `--dart-define=API_URL=…`.
final class ApiUrls {
  ApiUrls(Uri baseUri) : baseUri = _normalise(baseUri);

  /// Origin plus optional path prefix, without trailing slash, query or
  /// fragment.
  final Uri baseUri;

  /// Base for REST calls; Dio resolves `ApiEndpoints` paths against it.
  String get restBaseUrl => baseUri.toString();

  Uri get graphql => _withPath(GraphQLEndpoints.path);

  /// [token] is omitted in web cookie mode after a refresh: `EventSource`
  /// then authenticates with the HttpOnly cookie (`withCredentials`).
  Uri events({String? token}) => _withPath(SseEndpoints.path, token: token);

  /// Same host with a `ws`/`wss` scheme. Without [token] the handshake relies
  /// on the browser sending the HttpOnly cookie.
  Uri webSocket({String? token}) =>
      _withPath(WebSocketEndpoints.path, token: token).replace(
        scheme: baseUri.scheme == UrlConstants.https
            ? UrlConstants.wss
            : UrlConstants.ws,
      );

  Uri _withPath(String path, {String? token}) => baseUri.replace(
    path: baseUri.path + path,
    queryParameters: token == null || token.isEmpty
        ? null
        : {UrlConstants.tokenQueryParam: token},
  );

  static Uri _normalise(Uri uri) {
    var path = uri.path;
    while (path.endsWith(UrlConstants.pathSeparator)) {
      path = path.substring(0, path.length - 1);
    }
    return Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.hasPort ? uri.port : null,
      path: path,
    );
  }
}
