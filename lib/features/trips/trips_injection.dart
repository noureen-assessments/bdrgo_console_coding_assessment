import '../../core/di/injection_container.dart';
import 'data/datasources/trips_remote_data_source.dart';
import 'data/repositories/trips_repository_impl.dart';
import 'domain/repositories/trips_repository.dart';
import 'domain/usecases/get_trips_use_case.dart';
import 'presentation/bloc/trips/trips_bloc.dart';

void initTrips() {
  sl
    ..registerLazySingleton<TripsRemoteDataSource>(
      () => TripsRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<TripsRepository>(() => TripsRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetTripsUseCase(sl()))
    ..registerFactory<TripsBloc>(() => TripsBloc(getTrips: sl()));
}
