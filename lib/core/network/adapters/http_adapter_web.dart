import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

/// Web: with [withCredentials] the browser stores the server's `HttpOnly`
/// cookie and sends it on every cross-origin request. The server must answer
/// with `Access-Control-Allow-Credentials: true` and an explicit origin.
HttpClientAdapter createHttpClientAdapter({required bool withCredentials}) =>
    BrowserHttpClientAdapter(withCredentials: withCredentials);
