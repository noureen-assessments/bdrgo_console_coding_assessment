import '../../core/di/injection_container.dart';
import 'data/datasources/trips_remote_data_source.dart';
import 'data/repositories/trips_repository_impl.dart';
import 'domain/repositories/trips_repository.dart';
import 'domain/usecases/get_available_drivers_use_case.dart';
import 'domain/usecases/get_trip_detail_use_case.dart';
import 'domain/usecases/get_trip_use_case.dart';
import 'domain/usecases/get_trips_use_case.dart';
import 'domain/usecases/perform_trip_action_use_case.dart';
import 'domain/usecases/watch_trip_changes_use_case.dart';
import 'presentation/bloc/available_drivers/available_drivers_bloc.dart';
import 'presentation/bloc/trip_action/trip_action_bloc.dart';
import 'presentation/bloc/trip_detail/trip_detail_bloc.dart';
import 'presentation/bloc/trips/trips_bloc.dart';

void initTrips() {
  sl
    ..registerLazySingleton<TripsRemoteDataSource>(
      () => TripsRemoteDataSourceImpl(sl(), sl(), sl()),
    )
    ..registerLazySingleton<TripsRepository>(() => TripsRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetTripsUseCase(sl()))
    ..registerLazySingleton(() => GetTripUseCase(sl()))
    ..registerLazySingleton(() => GetTripDetailUseCase(sl()))
    ..registerLazySingleton(() => WatchTripChangesUseCase(sl()))
    ..registerLazySingleton(() => PerformTripActionUseCase(sl()))
    ..registerLazySingleton(() => GetAvailableDriversUseCase(sl()))
    ..registerFactory<TripsBloc>(() => TripsBloc(getTrips: sl(), getTrip: sl(), watchTripChanges: sl()),
    )
    ..registerFactory<TripActionBloc>(
      () => TripActionBloc(performTripAction: sl()),
    )
    ..registerFactory<AvailableDriversBloc>(
      () => AvailableDriversBloc(getAvailableDrivers: sl()),
    )
    ..registerFactory<TripDetailBloc>(
      () => TripDetailBloc(getTripDetail: sl(), watchTripChanges: sl()),
    );
}
