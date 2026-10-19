import 'package:badrgo_console_assesment/core/errors/api_error_parser.dart';
import 'package:badrgo_console_assesment/core/errors/failures.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, Object?> _rest(String code, [Map<String, Object?>? details]) => {
  'error': {'code': code, 'message': 'msg', 'details': ?details},
};

void main() {
  group('ApiErrorParser.fromRestBody', () {
    test('maps each server code to its failure type', () {
      expect(
        ApiErrorParser.fromRestBody(_rest('UNAUTHENTICATED'), 401),
        isA<UnauthenticatedFailure>(),
      );
      expect(
        ApiErrorParser.fromRestBody(_rest('FORBIDDEN'), 403),
        isA<ForbiddenFailure>(),
      );
      expect(
        ApiErrorParser.fromRestBody(_rest('NOT_FOUND'), 404),
        isA<NotFoundFailure>(),
      );
      expect(
        ApiErrorParser.fromRestBody(_rest('INVALID_STATE'), 409),
        isA<InvalidStateFailure>(),
      );
    });

    test('reads the bare { code, message } body of the auth endpoints', () {
      final failure = ApiErrorParser.fromRestBody({
        'code': 'INVALID_EMAIL_OR_PASSWORD',
        'message': 'Invalid email or password',
      }, 401);

      expect(
        failure,
        isA<ServerFailure>()
            .having((f) => f.message, 'message', 'Invalid email or password')
            .having((f) => f.code, 'code', 'INVALID_EMAIL_OR_PASSWORD'),
      );
    });

    test('keeps validation details', () {
      final failure = ApiErrorParser.fromRestBody(
        _rest('VALIDATION_FAILED', {'field': 'amount'}),
        422,
      );

      expect(
        failure,
        isA<ValidationFailure>()
            .having((f) => f.details, 'details', {'field': 'amount'})
            .having((f) => f.message, 'message', 'msg'),
      );
    });

    test('parses maintenance reason, retry and since', () {
      final failure = ApiErrorParser.fromRestBody(
        _rest('MAINTENANCE', {
          'reason': 'planned',
          'retryAfterSeconds': 30,
          'since': '2026-10-20T10:00:00Z',
        }),
        503,
      );

      expect(
        failure,
        isA<MaintenanceFailure>()
            .having((f) => f.reason, 'reason', 'planned')
            .having(
              (f) => f.retryAfter,
              'retryAfter',
              const Duration(seconds: 30),
            )
            .having((f) => f.since, 'since', DateTime.utc(2026, 10, 20, 10)),
      );
    });

    test('falls back to the HTTP status when the body has no code', () {
      expect(
        ApiErrorParser.fromRestBody('<html>', 401),
        isA<UnauthenticatedFailure>(),
      );
      expect(
        ApiErrorParser.fromRestBody(null, 500),
        isA<ServerFailure>().having((f) => f.statusCode, 'status', 500),
      );
    });

    test('keeps unknown server codes on ServerFailure', () {
      expect(
        ApiErrorParser.fromRestBody(_rest('RATE_LIMITED'), 429),
        isA<ServerFailure>().having((f) => f.code, 'code', 'RATE_LIMITED'),
      );
    });
  });

  test('fromGraphQLError reads extensions.code', () {
    final failure = ApiErrorParser.fromGraphQLError({
      'message': 'Trip not found',
      'extensions': {'code': 'NOT_FOUND'},
    });

    expect(
      failure,
      isA<NotFoundFailure>().having(
        (f) => f.message,
        'message',
        'Trip not found',
      ),
    );
  });

  test('fromDioException maps connection problems to NetworkFailure', () {
    final failure = ApiErrorParser.fromDioException(
      DioException.connectionError(
        requestOptions: RequestOptions(),
        reason: 'offline',
      ),
    );

    expect(failure, isA<NetworkFailure>());
  });
}
