import 'package:dio/dio.dart';

import '../../constants/api_error_constants.dart';
import '../../constants/api_headers.dart';
import '../../constants/log_constants.dart';
import '../../errors/api_error_parser.dart';
import '../../errors/failures.dart';
import '../../session/access_denied_notifier.dart';
import '../../session/maintenance_notifier.dart';
import '../../session/session_expiry_notifier.dart';
import '../../storage/token_storage.dart';
import '../../utils/logger.dart';

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


final class MaintenanceInterceptor extends Interceptor {
  MaintenanceInterceptor(this._maintenance);

  final MaintenanceNotifier _maintenance;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    if (status == ApiStatusCodes.serviceUnavailable) {
      final failure = ApiErrorParser.fromDioException(err);
      if (failure is MaintenanceFailure) _maintenance.notify(failure);
    }
    handler.next(err);
  }
}


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
