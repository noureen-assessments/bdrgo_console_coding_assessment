import 'package:dio/dio.dart';

import '../constants/app_strings.dart';
import '../constants/graphql_endpoints.dart';
import '../errors/api_error_parser.dart';
import '../errors/failures.dart';
import 'api_urls.dart';

/// GraphQL-over-HTTP transport. The console only sends queries with
/// variables, so a thin POST wrapper on the shared Dio beats a full client
/// with its own cache that would fight live SSE updates.
abstract interface class GraphQLConsumer {
  /// Returns the `data` object, or throws a [Failure] built from the first
  /// GraphQL error (`extensions.code`) or the HTTP error.
  Future<Map<String, Object?>> query(
    String document, {
    Map<String, Object?> variables = const {},
    String? operationName,
    CancelToken? cancelToken,
  });
}

final class DioGraphQLConsumer implements GraphQLConsumer {
  DioGraphQLConsumer(this._dio, this._urls);

  final Dio _dio;
  final ApiUrls _urls;

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
    if (failure != null) throw failure;
    final data = body[GraphQLKeys.data];
    return data is Map ? data.cast<String, Object?>() : const {};
  }
}
