import '../../core/di/injection_container.dart';
import 'data/datasources/dashboard_remote_data_source.dart';
import 'data/repositories/dashboard_repository_impl.dart';
import 'domain/repositories/dashboard_repository.dart';
import 'domain/usecases/get_kpis_use_case.dart';
import 'domain/usecases/watch_kpis_use_case.dart';
import 'domain/usecases/watch_live_status_use_case.dart';
import 'presentation/bloc/dashboard/dashboard_bloc.dart';

void initDashboard() {
  sl
    ..registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(sl(), sl()),
    )
    ..registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetKpisUseCase(sl()))
    ..registerLazySingleton(() => WatchKpisUseCase(sl()))
    ..registerLazySingleton(() => WatchLiveStatusUseCase(sl()))
    ..registerFactory<DashboardBloc>(
      () =>
          DashboardBloc(getKpis: sl(), watchKpis: sl(), watchLiveStatus: sl()),
    );
}
