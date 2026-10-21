import '../../core/di/injection_container.dart';
import 'data/datasources/alerts_remote_data_source.dart';
import 'data/repositories/alerts_repository_impl.dart';
import 'domain/repositories/alerts_repository.dart';
import 'domain/usecases/get_alerts_use_case.dart';
import 'domain/usecases/watch_alerts_live_status_use_case.dart';
import 'domain/usecases/watch_alerts_use_case.dart';
import 'presentation/bloc/alerts/alerts_bloc.dart';

void initAlerts() {
  sl
    ..registerLazySingleton<AlertsRemoteDataSource>(
      () => AlertsRemoteDataSourceImpl(sl(), sl()),
    )
    ..registerLazySingleton<AlertsRepository>(
      () => AlertsRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetAlertsUseCase(sl()))
    ..registerLazySingleton(() => WatchAlertsUseCase(sl()))
    ..registerLazySingleton(() => WatchAlertsLiveStatusUseCase(sl()))
    ..registerFactory<AlertsBloc>(
      () => AlertsBloc(
        getAlerts: sl(),
        watchAlerts: sl(),
        watchLiveStatus: sl(),
      ),
    );
}
