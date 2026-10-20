import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../config/env/env.dart';
import '../../config/flavor/flavor_config.dart';
import '../../config/routing/app_router.dart';
import '../../features/auth/auth_injection.dart';
import '../../features/connectivity/connectivity_injection.dart';
import '../../features/dashboard/dashboard_injection.dart';
import '../../features/live_map/live_map_injection.dart';
import '../../features/trips/trips_injection.dart';
import '../network/adapters/http_adapter.dart';
import '../network/api_consumer.dart';
import '../network/api_urls.dart';
import '../network/dio_consumer.dart';
import '../network/graphql_consumer.dart';
import '../network/interceptors/api_interceptors.dart';
import '../network/sse/sse_client.dart';
import '../network/sse/sse_client_impl.dart';
import '../network/sse/sse_transport_factory.dart';
import '../network/websocket/websocket_service.dart';
import '../network/websocket/websocket_service_impl.dart';
import '../session/access_denied_notifier.dart';
import '../session/session_checker.dart';
import '../session/session_expiry_notifier.dart';
import '../storage/in_memory_token_storage.dart';
import '../storage/token_storage.dart';
import '../utils/secure_storage.dart';

final GetIt sl = GetIt.instance;


Future<void> initCore(FlavorConfig flavorConfig) async {
  final useHttpOnlyCookie = Env.usesHttpOnlyCookie;
  final tokenStorage = _createTokenStorage(useHttpOnlyCookie);
  await tokenStorage.getToken();

  sl
    ..registerSingleton<FlavorConfig>(flavorConfig)
    ..registerSingleton<ApiUrls>(ApiUrls(flavorConfig.values.baseUri))
    ..registerSingleton<TokenStorage>(tokenStorage)
    ..registerSingleton<SessionExpiryNotifier>(SessionExpiryNotifier())
    ..registerSingleton<AccessDeniedNotifier>(AccessDeniedNotifier());

  sl
    ..registerLazySingleton<Dio>(
      () => _createDio(
        sl(),
        sl(),
        sl(),
        sl(),
        withCredentials: useHttpOnlyCookie,
      ),
    )
    ..registerLazySingleton<ApiConsumer>(() => DioConsumer(sl()))
    ..registerLazySingleton<GraphQLConsumer>(
      () => DioGraphQLConsumer(sl(), sl(), sl(), sl()),
    )
    ..registerLazySingleton<SessionChecker>(() => RestSessionChecker(sl()))
    ..registerLazySingleton<SseClient>(
      () => SseClientImpl(
        transport: createSseTransport(),
        urls: sl(),
        tokenStorage: sl(),
        sessionChecker: sl(),
        withCredentials: useHttpOnlyCookie,
      ),
    )
    ..registerLazySingleton<WebSocketService>(
      () => WebSocketServiceImpl(
        urls: sl(),
        tokenStorage: sl(),
        sessionChecker: sl(),
      ),
    );

  initConnectivity();
  initAuth();
  initDashboard();
  initTrips();
  initLiveMap();

  sl.registerLazySingleton<AppRouter>(() => AppRouter(session: sl()));
}

TokenStorage _createTokenStorage(bool useHttpOnlyCookie) =>
    useHttpOnlyCookie ? InMemoryTokenStorage() : AppSecureStorage();

Dio _createDio(
  ApiUrls urls,
  TokenStorage tokenStorage,
  SessionExpiryNotifier sessionExpiry,
  AccessDeniedNotifier accessDenied, {
  required bool withCredentials,
}) {
  final dio =
      Dio(
          BaseOptions(
            baseUrl: urls.restBaseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 30),
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        )
        ..httpClientAdapter = createHttpClientAdapter(
          withCredentials: withCredentials,
        );
  dio.interceptors.add(
    AuthInterceptor(tokenStorage, sessionExpiry, accessDenied),
  );
  if (kDebugMode) dio.interceptors.add(LoggingInterceptor());
  return dio;
}
