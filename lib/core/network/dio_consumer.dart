import 'package:dio/dio.dart';

import '../errors/api_error_parser.dart';
import 'api_consumer.dart';

final class DioConsumer implements ApiConsumer {
  DioConsumer(this._dio);

  final Dio _dio;

  @override
  Future<Object?> get(
    String path, {
    Map<String, Object?>? queryParameters,
    CancelToken? cancelToken,
  }) => _send(
    () => _dio.get<Object?>(
      path,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    ),
  );

  @override
  Future<Object?> post(String path, {Object? data, CancelToken? cancelToken}) =>
      _send(
        () => _dio.post<Object?>(path, data: data, cancelToken: cancelToken),
      );

  @override
  Future<Object?> patch(
    String path, {
    Object? data,
    CancelToken? cancelToken,
  }) => _send(
    () => _dio.patch<Object?>(path, data: data, cancelToken: cancelToken),
  );

  @override
  Future<Object?> delete(
    String path, {
    Object? data,
    CancelToken? cancelToken,
  }) => _send(
    () => _dio.delete<Object?>(path, data: data, cancelToken: cancelToken),
  );

  Future<Object?> _send(Future<Response<Object?>> Function() request) async {
    try {
      return (await request()).data;
    } on DioException catch (exception) {
      throw ApiErrorParser.fromDioException(exception);
    }
  }
}
