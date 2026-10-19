import 'package:badrgo_console_assesment/core/network/interceptors/api_interceptors.dart';
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

void main() {
  late _MockTokenStorage tokenStorage;
  late AuthInterceptor interceptor;

  setUp(() {
    tokenStorage = _MockTokenStorage();
    interceptor = AuthInterceptor(tokenStorage);
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
}
