import '../constants/graphql_endpoints.dart';
import '../constants/sse_events.dart';
import '../constants/url_constants.dart';
import '../constants/websocket_events.dart';


final class ApiUrls {
  ApiUrls(Uri baseUri) : baseUri = _normalise(baseUri);

  final Uri baseUri;
  String get restBaseUrl => baseUri.toString();
  Uri get graphql => _withPath(GraphQLEndpoints.path);
  Uri events({String? token}) => _withPath(SseEndpoints.path, token: token);

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
