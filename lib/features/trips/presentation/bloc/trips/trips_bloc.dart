import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../../shared/use_cases/use_case.dart';
import '../../../domain/entities/trip_change.dart';
import '../../../domain/entities/trip_filter.dart';
import '../../../domain/entities/trip_page.dart';
import '../../../domain/entities/trip_page_request.dart';
import '../../../domain/usecases/get_trip_use_case.dart';
import '../../../domain/usecases/get_trips_use_case.dart';
import '../../../domain/usecases/watch_trip_changes_use_case.dart';

part 'trips_event.dart';
part 'trips_state.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  TripsBloc({required GetTripsUseCase getTrips,
    required GetTripUseCase getTrip,
    required WatchTripChangesUseCase watchTripChanges,
  }) : _getTrips = getTrips,
       _getTrip = getTrip,
       _watchTripChanges = watchTripChanges,
       super(const TripsLoading(TripFilter())) {
    on<TripsStarted>(_onStarted);
    on<TripsFilterChanged>(_onFilterChanged, transformer: restartable());
    on<TripsRefreshRequested>((event, emit) {
      add(TripsFilterChanged(state.filter));
    });
    on<TripsNextPageRequested>(_onNextPageRequested, transformer: droppable());
    on<TripsTripChanged>(_onTripChanged);
  }

  final GetTripsUseCase _getTrips;
  final GetTripUseCase _getTrip;
  final WatchTripChangesUseCase _watchTripChanges;


  Future<void> _onStarted(TripsStarted event, Emitter<TripsState> emit) {
    add(const TripsFilterChanged(TripFilter()));
    return emit.onEach(
      _watchTripChanges(const NoParams()),
      onData: (change) => add(TripsTripChanged(change)),
    );
  }

  Future<void> _onFilterChanged(
    TripsFilterChanged event,
    Emitter<TripsState> emit,
  ) async {
    emit(TripsLoading(event.filter));
    final result = await _getTrips(TripPageRequest(filter: event.filter));
    emit(
      result.fold(
        (failure) => TripsError(event.filter, failure.message),
        (page) => TripsLoaded(event.filter, page),
      ),
    );
  }

  Future<void> _onNextPageRequested(
    TripsNextPageRequested event,
    Emitter<TripsState> emit,
  ) async {
    final current = state;
    if (current is! TripsLoaded || !current.page.hasNextPage) return;
    emit(TripsLoaded(current.filter, current.page,
        marks: current.marks,
        isLoadingMore: true,
      ),
    );
    final result = await _getTrips(
      TripPageRequest(filter: current.filter, after: current.page.endCursor),
    );
    final latest = state;
    if (latest is! TripsLoaded || !latest.isLoadingMore) return;
    emit(
      result.fold(
        (failure) => TripsLoaded(
          latest.filter,
          latest.page,
          marks: latest.marks,
          nextPageError: failure.message,
        ),
        (next) => TripsLoaded(latest.filter, latest.page.append(next),
          marks: latest.marks,
        ),
      ),
    );
  }


  Future<void> _onTripChanged(
    TripsTripChanged event,
    Emitter<TripsState> emit,
  ) async {
    final change = event.change;
    final current = state;
    if (current is! TripsLoaded) return;
    if (!change.isNew && !current.page.contains(change.tripId)) return;

    final result = await _getTrip(change.tripId);
    final trip = result.fold((_) => null, (trip) => trip);

    if (trip == null) return;

    final latest = state;
    if (latest is! TripsLoaded || latest.filter != current.filter) return;

    final mark = change.isNew ? TripMark.added : TripMark.updated;
    final shown = latest.page.find(trip.id);
    if (shown != null) {
      if (trip.isOlderThan(shown)) return;
      emit(latest.withRow(latest.page.replace(trip), trip.id, mark));
    } else if (change.isNew && latest.filter.matches(trip)) {
      emit(latest.withRow(latest.page.addOnTop(trip), trip.id, mark));
    }
  }
}
