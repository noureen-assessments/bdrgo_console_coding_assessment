import 'package:dio/dio.dart';

import '../../constants/api_headers.dart';
import '../../constants/log_constants.dart';
import '../../storage/token_storage.dart';
import '../../utils/logger.dart';

/// Adds the bearer token to every HTTP request (REST and GraphQL).
final class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage);

  final TokenStorage _tokenStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers[ApiHeaders.authorization] = ApiHeaders.bearer(token);
    }
    handler.next(options);
  }
}

/// Logs method, URL and status only. Headers and bodies carry tokens and
/// passwords, so they are never logged.
final class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.info(
      LogMessages.httpRequest(options.method, options.uri),
      name: LogTags.http,
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger.info(
      LogMessages.httpResponse(
        response.statusCode,
        response.requestOptions.uri,
      ),
      name: LogTags.http,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.warning(
      LogMessages.httpResponse(
        err.response?.statusCode ?? err.type.name,
        err.requestOptions.uri,
      ),
      name: LogTags.http,
    );
    handler.next(err);
  }
}
