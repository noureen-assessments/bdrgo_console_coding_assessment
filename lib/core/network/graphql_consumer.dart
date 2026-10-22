import 'package:dio/dio.dart';

import '../constants/app_strings.dart';
import '../constants/graphql_endpoints.dart';
import '../errors/api_error_parser.dart';
import '../errors/failures.dart';
import '../session/access_denied_notifier.dart';
import '../session/session_expiry_notifier.dart';
import 'api_urls.dart';

abstract interface class GraphQLConsumer {
  Future<Map<String, Object?>> query(
    String document, {
    Map<String, Object?> variables = const {},
    String? operationName,
    CancelToken? cancelToken,
  });
}

final class DioGraphQLConsumer implements GraphQLConsumer {
  DioGraphQLConsumer(
    this._dio,
    this._urls,
    this._sessionExpiry,
    this._accessDenied,
  );

  final Dio _dio;
  final ApiUrls _urls;
  final SessionExpiryNotifier _sessionExpiry;
  final AccessDeniedNotifier _accessDenied;

  @override
  Future<Map<String, Object?>> query(
    String document, {
    Map<String, Object?> variables = const {},
    String? operationName,
    CancelToken? cancelToken,
  }) async {
    final Response<Object?> response;
    try {
      response = await _dio.postUri<Object?>(
        _urls.graphql,
        data: {
          GraphQLKeys.query: document,
          GraphQLKeys.variables: variables,
          GraphQLKeys.operationName: ?operationName,
        },
        cancelToken: cancelToken,
      );
    } on DioException catch (exception) {
      final status = exception.response?.statusCode;
      throw ApiErrorParser.fromGraphQLBody(
            exception.response?.data,
            statusCode: status,
          ) ??
          ApiErrorParser.fromDioException(exception);
    }
    return _unwrap(response.data, response.statusCode);
  }

  Map<String, Object?> _unwrap(Object? body, int? status) {
    if (body is! Map) {
      throw ServerFailure(AppStrings.unexpectedResponse, statusCode: status);
    }
    final failure = ApiErrorParser.fromGraphQLBody(body, statusCode: status);
    if (failure is UnauthenticatedFailure) _sessionExpiry.notify();
    if (failure is ForbiddenFailure) _accessDenied.notify();
    if (failure != null) throw failure;
    final data = body[GraphQLKeys.data];
    return data is Map ? data.cast<String, Object?>() : const {};
  }
}
