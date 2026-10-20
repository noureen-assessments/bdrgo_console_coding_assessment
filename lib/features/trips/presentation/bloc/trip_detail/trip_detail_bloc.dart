import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../shared/use_cases/use_case.dart';
import '../../../domain/entities/trip_detail.dart';
import '../../../domain/usecases/get_trip_detail_use_case.dart';
import '../../../domain/usecases/watch_trip_changes_use_case.dart';

part 'trip_detail_event.dart';
part 'trip_detail_state.dart';

class TripDetailBloc extends Bloc<TripDetailEvent, TripDetailState> {
  TripDetailBloc({required GetTripDetailUseCase getTripDetail,
    required WatchTripChangesUseCase watchTripChanges,
  }) : _getTripDetail = getTripDetail,
       _watchTripChanges = watchTripChanges,
       super(const TripDetailLoading()) {
    on<TripDetailStarted>(_onStarted);
    on<TripDetailRequested>(_onRequested, transformer: restartable());
  }

  final GetTripDetailUseCase _getTripDetail;
  final WatchTripChangesUseCase _watchTripChanges;

  Future<void> _onStarted(
    TripDetailStarted event,
    Emitter<TripDetailState> emit,
  ) {
    add(TripDetailRequested(event.tripId));
    final changesOfThisTrip = _watchTripChanges(
      const NoParams(),
    ).where((change) => change.tripId == event.tripId);
    return emit.onEach(
      changesOfThisTrip,
      onData: (_) => add(TripDetailRequested(event.tripId)),
    );
  }

  Future<void> _onRequested(
    TripDetailRequested event,
    Emitter<TripDetailState> emit,
  ) async {
    if (state is! TripDetailLoaded) emit(const TripDetailLoading());
    final result = await _getTripDetail(event.tripId);
    result.fold(
      (failure) {
        if (failure is NotFoundFailure) {
          emit(const TripDetailNotFound());
        } else if (state is! TripDetailLoaded) {
          emit(TripDetailError(failure.message));
        }
      },
      (trip) {
        if (trip == null) {
          emit(const TripDetailNotFound());
        } else {
          emit(TripDetailLoaded(trip));
        }
      },
    );
  }
}
