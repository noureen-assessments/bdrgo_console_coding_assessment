import 'package:dio/dio.dart';

import '../constants/api_error_constants.dart';
import '../constants/app_strings.dart';
import '../constants/graphql_endpoints.dart';
import 'failures.dart';

/// Builds [Failure]s from transport errors.
///
/// REST: `{ "error": { "code", "message", "details" } }`. The Better Auth
/// endpoints (sign-in, sign-out) answer `{ "code", "message" }` instead.
/// GraphQL: `{ "errors": [ { "message", "extensions": { "code", … } } ] }`.
abstract final class ApiErrorParser {
  static Failure fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.cancel:
        return const CancelledFailure(AppStrings.requestCancelled);
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure(AppStrings.noConnection);
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        final response = exception.response;
        return fromRestBody(response?.data, response?.statusCode);
    }
  }

  static Failure fromRestBody(Object? body, int? statusCode) {
    final envelope = body is Map ? body[ApiErrorKeys.error] : null;
    final error = envelope is Map ? envelope : body;
    if (error is! Map) {
      return _build(null, AppStrings.unexpectedResponse, const {}, statusCode);
    }
    return _build(
      error[ApiErrorKeys.code],
      _message(error[ApiErrorKeys.message]),
      _asMap(error[ApiErrorKeys.details]),
      statusCode,
    );
  }

  static Failure fromGraphQLError(Object? error, {int? statusCode}) {
    final map = error is Map ? error : const {};
    final extensions = _asMap(map[ApiErrorKeys.extensions]);
    return _build(
      extensions[ApiErrorKeys.code],
      _message(map[ApiErrorKeys.message]),
      extensions,
      statusCode,
    );
  }

  /// First error of a GraphQL response body, or null when there is none.
  static Failure? fromGraphQLBody(Object? body, {int? statusCode}) {
    final errors = body is Map ? body[GraphQLKeys.errors] : null;
    if (errors is! List || errors.isEmpty) return null;
    return fromGraphQLError(errors.first, statusCode: statusCode);
  }

  static Failure _build(
    Object? code,
    String message,
    Map<String, Object?> details,
    int? status,
  ) {
    final resolved = code is String ? code : _codeForStatus(status);
    return switch (resolved) {
      ApiErrorCodes.unauthenticated => UnauthenticatedFailure(
        message,
        statusCode: status,
      ),
      ApiErrorCodes.forbidden => ForbiddenFailure(message, statusCode: status),
      ApiErrorCodes.notFound => NotFoundFailure(message, statusCode: status),
      ApiErrorCodes.invalidState => InvalidStateFailure(
        message,
        statusCode: status,
      ),
      ApiErrorCodes.validationFailed => ValidationFailure(
        message,
        details: details,
        statusCode: status,
      ),
      ApiErrorCodes.maintenance => MaintenanceFailure(
        message,
        reason: _string(details[ApiErrorKeys.reason]),
        retryAfter: _seconds(details[ApiErrorKeys.retryAfterSeconds]),
        since: _date(details[ApiErrorKeys.since]),
        statusCode: status,
      ),
      _ => ServerFailure(message, code: resolved, statusCode: status),
    };
  }

  static String? _codeForStatus(int? status) => switch (status) {
    ApiStatusCodes.unauthorized => ApiErrorCodes.unauthenticated,
    ApiStatusCodes.forbidden => ApiErrorCodes.forbidden,
    ApiStatusCodes.notFound => ApiErrorCodes.notFound,
    ApiStatusCodes.conflict => ApiErrorCodes.invalidState,
    ApiStatusCodes.unprocessableEntity => ApiErrorCodes.validationFailed,
    ApiStatusCodes.serviceUnavailable => ApiErrorCodes.maintenance,
    _ => null,
  };

  static String? _string(Object? value) => value is String ? value : null;

  static DateTime? _date(Object? value) =>
      value is String ? DateTime.tryParse(value) : null;

  static Duration? _seconds(Object? value) =>
      value is num ? Duration(seconds: value.toInt()) : null;

  static String _message(Object? value) =>
      value is String && value.isNotEmpty ? value : AppStrings.unexpectedError;

  static Map<String, Object?> _asMap(Object? value) =>
      value is Map ? value.cast<String, Object?>() : const {};
}
