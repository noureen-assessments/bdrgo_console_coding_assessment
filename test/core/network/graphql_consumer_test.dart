import 'dart:convert';

import 'package:badrgo_console_assesment/core/errors/failures.dart';
import 'package:badrgo_console_assesment/core/network/api_urls.dart';
import 'package:badrgo_console_assesment/core/network/graphql_consumer.dart';
import 'package:badrgo_console_assesment/core/session/access_denied_notifier.dart';
import 'package:badrgo_console_assesment/core/session/session_expiry_notifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.status, this.body);

  final int status;
  final Object body;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  final urls = ApiUrls(Uri.parse('https://api.test'));
  late SessionExpiryNotifier sessionExpiry;
  late AccessDeniedNotifier accessDenied;

  setUp(() {
    sessionExpiry = SessionExpiryNotifier();
    accessDenied = AccessDeniedNotifier();
  });

  DioGraphQLConsumer consumerWith(_FakeAdapter adapter) => DioGraphQLConsumer(
    Dio()..httpClientAdapter = adapter,
    urls,
    sessionExpiry,
    accessDenied,
  );

  test('returns data and posts query with variables to /graphql', () async {
    final adapter = _FakeAdapter(200, {
      'data': {
        'kpis': {'activeTrips': 3},
      },
    });

    final data = await consumerWith(
      adapter,
    ).query('query { kpis { activeTrips } }', variables: {'city': 'doha'});

    expect(data['kpis'], {'activeTrips': 3});
    expect('${adapter.lastRequest?.uri}', 'https://api.test/graphql');
    expect((adapter.lastRequest?.data as Map)['variables'], {'city': 'doha'});
  });

  test('throws the extensions.code failure on a 200 with errors', () {
    final adapter = _FakeAdapter(200, {
      'data': null,
      'errors': [
        {
          'message': 'Not allowed',
          'extensions': {'code': 'FORBIDDEN'},
        },
      ],
    });

    expect(
      consumerWith(adapter).query('query { kpis { activeTrips } }'),
      throwsA(isA<ForbiddenFailure>()),
    );
  });

  test('throws the GraphQL failure for HTTP errors carrying errors', () {
    final adapter = _FakeAdapter(401, {
      'errors': [
        {
          'message': 'Token expired',
          'extensions': {'code': 'UNAUTHENTICATED'},
        },
      ],
    });

    expect(
      consumerWith(adapter).query('query { me { id } }'),
      throwsA(
        isA<UnauthenticatedFailure>().having(
          (f) => f.statusCode,
          'status',
          401,
        ),
      ),
    );
  });

  test('falls back to the REST envelope for non-GraphQL HTTP errors', () {
    final adapter = _FakeAdapter(503, {
      'error': {'code': 'MAINTENANCE', 'message': 'Restarting'},
    });

    expect(
      consumerWith(adapter).query('query { me { id } }'),
      throwsA(isA<MaintenanceFailure>()),
    );
  });

  test('reports UNAUTHENTICATED on a 200 as an expired session', () async {
    final adapter = _FakeAdapter(200, {
      'data': null,
      'errors': [
        {
          'message': 'Sign in first',
          'extensions': {'code': 'UNAUTHENTICATED'},
        },
      ],
    });
    final expired = expectLater(sessionExpiry.onExpired, emits(null));

    await expectLater(
      consumerWith(adapter).query('query { kpis { activeTrips } }'),
      throwsA(isA<UnauthenticatedFailure>()),
    );
    await expired;
  });

  test('reports FORBIDDEN on a 200 as denied access', () async {
    final adapter = _FakeAdapter(200, {
      'data': null,
      'errors': [
        {
          'message': 'Not allowed',
          'extensions': {'code': 'FORBIDDEN'},
        },
      ],
    });
    final denied = expectLater(accessDenied.onDenied, emits(null));

    await expectLater(
      consumerWith(adapter).query('query { kpis { activeTrips } }'),
      throwsA(isA<ForbiddenFailure>()),
    );
    await denied;
  });
}
