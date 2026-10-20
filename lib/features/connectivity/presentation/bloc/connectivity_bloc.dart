import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/use_cases/use_case.dart';
import '../../domain/usecases/watch_connectivity_use_case.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';


class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc(this._watchConnectivity)
    : super(const ConnectivityOnline()) {
    on<ConnectivityStarted>(
      (event, emit) => emit.forEach<bool>(
        _watchConnectivity(const NoParams()),
        onData: (online) =>
            online ? const ConnectivityOnline() : const ConnectivityOffline(),
      ),
    );
  }

  final WatchConnectivityUseCase _watchConnectivity;
}
