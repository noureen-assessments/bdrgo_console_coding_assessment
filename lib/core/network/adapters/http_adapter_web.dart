import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

HttpClientAdapter createHttpClientAdapter({required bool withCredentials}) =>
    BrowserHttpClientAdapter(withCredentials: withCredentials);
