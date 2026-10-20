import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../config/env/env.dart';
import '../../config/flavor/flavor_config.dart';
import '../../config/routing/app_router.dart';
import '../../features/auth/auth_injection.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/connectivity/connectivity_injection.dart';
import '../network/adapters/http_adapter.dart';
import '../network/api_consumer.dart';
import '../network/api_urls.dart';
import '../network/dio_consumer.dart';
import '../network/graphql_consumer.dart';
import '../network/interceptors/api_interceptors.dart';
import '../session/access_denied_notifier.dart';
import '../session/session_expiry_notifier.dart';
import '../storage/in_memory_token_storage.dart';
import '../storage/token_storage.dart';
import '../utils/secure_storage.dart';

/// Service locator. Read only in the composition root (main, router, Bloc
/// providers); every other class gets dependencies through its constructor.
final GetIt sl = GetIt.instance;

/// Registers core services, then each feature's `init<Feature>()` from its
/// `<feature>_injection.dart` as features are added.
Future<void> initCore(FlavorConfig flavorConfig) async {
  final useHttpOnlyCookie = Env.usesHttpOnlyCookie;
  final tokenStorage = _createTokenStorage(useHttpOnlyCookie);
  // Secure storage decrypts once here; later reads come from memory.
  await tokenStorage.getToken();

  // Config & storage
  sl
    ..registerSingleton<FlavorConfig>(flavorConfig)
    ..registerSingleton<ApiUrls>(ApiUrls(flavorConfig.values.baseUri))
    ..registerSingleton<TokenStorage>(tokenStorage)
    ..registerSingleton<SessionExpiryNotifier>(SessionExpiryNotifier())
    ..registerSingleton<AccessDeniedNotifier>(AccessDeniedNotifier());

  // Network
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
    );

  // Features
  initConnectivity();
  initAuth();

  // Routing
  sl.registerLazySingleton<AppRouter>(
    () =>
        AppRouter(isSignedIn: () => sl<AuthBloc>().state is AuthAuthenticated),
  );
}

/// Web cookie mode keeps nothing in browser storage (the server's HttpOnly
/// cookie is the credential). Mobile, and web storage mode, use the
/// platform's secure storage.
TokenStorage _createTokenStorage(bool useHttpOnlyCookie) =>
    useHttpOnlyCookie ? InMemoryTokenStorage() : AppSecureStorage();

/// One Dio for REST and GraphQL so both share the auth header, cookies and
/// logging. No `sendTimeout`: on web it only applies to requests with a body.
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
