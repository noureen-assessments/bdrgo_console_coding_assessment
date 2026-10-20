import '../../core/di/injection_container.dart';
import 'data/datasources/live_map_remote_data_source.dart';
import 'data/repositories/live_map_repository_impl.dart';
import 'domain/repositories/live_map_repository.dart';
import 'domain/usecases/get_driver_detail_use_case.dart';
import 'domain/usecases/watch_driver_locations_use_case.dart';
import 'domain/usecases/watch_map_live_status_use_case.dart';
import 'presentation/bloc/driver_detail/driver_detail_bloc.dart';
import 'presentation/bloc/live_map/live_map_bloc.dart';

void initLiveMap() {
  sl
    ..registerLazySingleton<LiveMapRemoteDataSource>(
      () => LiveMapRemoteDataSourceImpl(sl(), sl()),
    )
    ..registerLazySingleton<LiveMapRepository>(
      () => LiveMapRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => WatchDriverLocationsUseCase(sl()))
    ..registerLazySingleton(() => WatchMapLiveStatusUseCase(sl()))
    ..registerLazySingleton(() => GetDriverDetailUseCase(sl()))
    ..registerFactory<LiveMapBloc>(
      () => LiveMapBloc(watchDriverLocations: sl(), watchLiveStatus: sl()),
    )
    ..registerFactory<DriverDetailBloc>(
      () => DriverDetailBloc(getDriverDetail: sl()),
    );
}
