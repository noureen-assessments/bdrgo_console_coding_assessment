import 'package:dio/dio.dart';

/// Mobile/desktop: there are no browser cookies to opt into, so
/// [withCredentials] has no effect.
HttpClientAdapter createHttpClientAdapter({required bool withCredentials}) =>
    HttpClientAdapter();
