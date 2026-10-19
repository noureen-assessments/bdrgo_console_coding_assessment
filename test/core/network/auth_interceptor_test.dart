import 'package:badrgo_console_assesment/core/network/interceptors/api_interceptors.dart';
import 'package:badrgo_console_assesment/core/session/session_expiry_notifier.dart';
import 'package:badrgo_console_assesment/core/storage/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockTokenStorage extends Mock implements TokenStorage {}

class _CapturingHandler extends RequestInterceptorHandler {
  RequestOptions? passed;

  @override
  void next(RequestOptions requestOptions) => passed = requestOptions;
}

class _PassingErrorHandler extends ErrorInterceptorHandler {
  @override
  void next(DioException err) {}
}

DioException _unauthorized({required bool withToken}) {
  final options = RequestOptions(
    path: '/api/me',
    headers: {if (withToken) 'Authorization': 'Bearer jwt-1'},
  );
  return DioException(
    requestOptions: options,
    response: Response<Object?>(requestOptions: options, statusCode: 401),
  );
}

void main() {
  late _MockTokenStorage tokenStorage;
  late SessionExpiryNotifier sessionExpiry;
  late AuthInterceptor interceptor;

  setUp(() {
    tokenStorage = _MockTokenStorage();
    sessionExpiry = SessionExpiryNotifier();
    interceptor = AuthInterceptor(tokenStorage, sessionExpiry);
  });

  test('adds the bearer header when a token is stored', () async {
    when(tokenStorage.getToken).thenAnswer((_) async => 'jwt-1');
    final handler = _CapturingHandler();

    await interceptor.onRequest(RequestOptions(path: '/api/me'), handler);

    expect(handler.passed?.headers['Authorization'], 'Bearer jwt-1');
  });

  test('sends the request without a header when signed out', () async {
    when(tokenStorage.getToken).thenAnswer((_) async => null);
    final handler = _CapturingHandler();

    await interceptor.onRequest(RequestOptions(path: '/api/sign-in'), handler);

    expect(handler.passed, isNotNull);
    expect(handler.passed!.headers.containsKey('Authorization'), isFalse);
  });

  test('a 401 on an authenticated request reports the session expired', () {
    expectLater(sessionExpiry.onExpired, emits(null));

    interceptor.onError(_unauthorized(withToken: true), _PassingErrorHandler());
  });

  test(
    'a 401 without a token (wrong password) is not a session expiry',
    () async {
      var reported = false;
      final subscription = sessionExpiry.onExpired.listen(
        (_) => reported = true,
      );

      interceptor.onError(
        _unauthorized(withToken: false),
        _PassingErrorHandler(),
      );
      await Future<void>.delayed(Duration.zero);

      expect(reported, isFalse);
      await subscription.cancel();
    },
  );
}
