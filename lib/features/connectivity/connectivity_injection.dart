import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/di/injection_container.dart';
import 'data/repositories/connectivity_repository_impl.dart';
import 'domain/repositories/connectivity_repository.dart';
import 'domain/usecases/watch_connectivity_use_case.dart';
import 'presentation/bloc/connectivity_bloc.dart';

void initConnectivity() {
  sl
    ..registerLazySingleton<ConnectivityRepository>(
      () => ConnectivityRepositoryImpl(Connectivity()),
    )
    ..registerLazySingleton(() => WatchConnectivityUseCase(sl()))
    // App-wide: one status for the whole session.
    ..registerLazySingleton<ConnectivityBloc>(() => ConnectivityBloc(sl()));
}
