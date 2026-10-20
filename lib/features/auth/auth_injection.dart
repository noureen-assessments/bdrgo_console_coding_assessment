import '../../core/di/injection_container.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/services/session_access.dart';
import 'domain/usecases/restore_session_use_case.dart';
import 'domain/usecases/sign_in_use_case.dart';
import 'domain/usecases/sign_out_use_case.dart';
import 'domain/usecases/watch_access_denied_use_case.dart';
import 'domain/usecases/watch_session_expiry_use_case.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/sign_in/sign_in_bloc.dart';
import 'presentation/services/auth_bloc_session_access.dart';

void initAuth() {
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remote: sl(),
        tokenStorage: sl(),
        sessionExpiry: sl(),
        accessDenied: sl(),
      ),
    )
    ..registerLazySingleton(() => SignInUseCase(sl()))
    ..registerLazySingleton(() => SignOutUseCase(sl()))
    ..registerLazySingleton(() => RestoreSessionUseCase(sl()))
    ..registerLazySingleton(() => WatchSessionExpiryUseCase(sl()))
    ..registerLazySingleton(() => WatchAccessDeniedUseCase(sl()))
    // App-wide: the router and every page read the same session.
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        restoreSession: sl(),
        signOut: sl(),
        watchSessionExpiry: sl(),
        watchAccessDenied: sl(),
      ),
    )
    ..registerLazySingleton<SessionAccess>(() => AuthBlocSessionAccess(sl()))
    ..registerFactory<SignInBloc>(() => SignInBloc(signIn: sl()));
}
