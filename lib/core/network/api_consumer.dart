import 'package:dio/dio.dart';

/// REST transport used by remote data sources. Implementations throw a
/// `Failure` on error, so data sources never see Dio types except
/// [CancelToken].
abstract interface class ApiConsumer {
  Future<Object?> get(
    String path, {
    Map<String, Object?>? queryParameters,
    CancelToken? cancelToken,
  });

  Future<Object?> post(String path, {Object? data, CancelToken? cancelToken});

  Future<Object?> patch(String path, {Object? data, CancelToken? cancelToken});

  Future<Object?> delete(String path, {Object? data, CancelToken? cancelToken});
}
