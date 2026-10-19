import 'package:badrgo_console_assesment/core/errors/failures.dart';
import 'package:badrgo_console_assesment/core/utils/safe_call.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  test('returns Right with the value on success', () async {
    expect(await safeCall(() async => 42), const Right<Failure, int>(42));
  });

  test('returns Left with a thrown Failure unchanged', () async {
    const failure = InvalidStateFailure('Trip already completed');

    final result = await safeCall<int>(() async => throw failure);

    expect(result, const Left<Failure, int>(failure));
  });

  test('maps raw DioException and FormatException', () async {
    final dio = await safeCall<int>(
      () async => throw DioException.connectionTimeout(
        timeout: Duration.zero,
        requestOptions: RequestOptions(),
      ),
    );
    final format = await safeCall<int>(
      () async => throw const FormatException('bad json'),
    );

    expect(dio.getLeft().toNullable(), isA<NetworkFailure>());
    expect(format.getLeft().toNullable(), isA<ServerFailure>());
  });

  test('does not swallow programming errors', () {
    expect(
      safeCall<int>(() async => throw StateError('bug')),
      throwsStateError,
    );
  });
}
