import '../../core/di/injection_container.dart';
import 'data/datasources/maintenance_remote_data_source.dart';
import 'data/repositories/maintenance_repository_impl.dart';
import 'domain/repositories/maintenance_repository.dart';
import 'domain/usecases/poll_until_up_use_case.dart';
import 'domain/usecases/reconnect_realtime_use_case.dart';
import 'domain/usecases/watch_maintenance_use_case.dart';
import 'presentation/bloc/maintenance_bloc.dart';

void initMaintenance() {
  sl
    ..registerLazySingleton<MaintenanceRemoteDataSource>(
      () => MaintenanceRemoteDataSourceImpl(sl(), sl(), sl(), sl()),
    )
    ..registerLazySingleton<MaintenanceRepository>(
      () => MaintenanceRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => WatchMaintenanceUseCase(sl()))
    ..registerLazySingleton(() => PollUntilUpUseCase(sl()))
    ..registerLazySingleton(() => ReconnectRealtimeUseCase(sl()))
    ..registerLazySingleton<MaintenanceBloc>(
      () => MaintenanceBloc(
        watchMaintenance: sl(),
        pollUntilUp: sl(),
        reconnectRealtime: sl(),
      ),
    );
}
