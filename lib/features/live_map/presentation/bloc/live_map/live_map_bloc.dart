import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/use_cases/use_case.dart';
import '../../../domain/entities/driver_location.dart';
import '../../../domain/usecases/watch_driver_locations_use_case.dart';
import '../../../domain/usecases/watch_map_live_status_use_case.dart';

part 'live_map_event.dart';
part 'live_map_state.dart';

class LiveMapBloc extends Bloc<LiveMapEvent, LiveMapState> {
  LiveMapBloc({
    required WatchDriverLocationsUseCase watchDriverLocations,
    required WatchMapLiveStatusUseCase watchLiveStatus,
  }) : _watchDriverLocations = watchDriverLocations,
       _watchLiveStatus = watchLiveStatus,
       super(const LiveMapLoading()) {
    on<LiveMapStarted>(_onStarted);
  }

  final WatchDriverLocationsUseCase _watchDriverLocations;
  final WatchMapLiveStatusUseCase _watchLiveStatus;

  Future<void> _onStarted(
    LiveMapStarted event,
    Emitter<LiveMapState> emit,
  ) {
    return Future.wait([
      emit.onEach(
        _watchDriverLocations(const NoParams()),
        onData: (drivers) => emit(LiveMapLoaded(drivers, isLive: true)),
      ),
      emit.onEach(
        _watchLiveStatus(const NoParams()),
        onData: (isLive) {
          final current = state;
          if (current is LiveMapLoaded) {
            emit(LiveMapLoaded(current.drivers, isLive: isLive));
          }
        },
      ),
    ]);
  }
}
