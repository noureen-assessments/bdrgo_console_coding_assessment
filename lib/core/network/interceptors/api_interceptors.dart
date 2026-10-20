import 'package:dio/dio.dart';

import '../../constants/api_error_constants.dart';
import '../../constants/api_headers.dart';
import '../../constants/log_constants.dart';
import '../../session/access_denied_notifier.dart';
import '../../session/session_expiry_notifier.dart';
import '../../storage/token_storage.dart';
import '../../utils/logger.dart';

/// Adds the bearer token to every HTTP request (REST and GraphQL) and
/// reports, for authenticated requests, a `401` as an expired session and a
/// `403` as denied access (permissions may have changed).
///
/// Requests sent without a token (sign-in) are not reported, so a wrong
/// password never looks like an expired session.
final class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage, this._sessionExpiry, this._accessDenied);

  final TokenStorage _tokenStorage;
  final SessionExpiryNotifier _sessionExpiry;
  final AccessDeniedNotifier _accessDenied;

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

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final wasAuthenticated = err.requestOptions.headers.containsKey(
      ApiHeaders.authorization,
    );
    if (wasAuthenticated) {
      final status = err.response?.statusCode;
      if (status == ApiStatusCodes.unauthorized) _sessionExpiry.notify();
      if (status == ApiStatusCodes.forbidden) _accessDenied.notify();
    }
    handler.next(err);
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
