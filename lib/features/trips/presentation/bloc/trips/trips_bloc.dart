import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/trip_filter.dart';
import '../../../domain/entities/trip_page.dart';
import '../../../domain/entities/trip_page_request.dart';
import '../../../domain/usecases/get_trips_use_case.dart';

part 'trips_event.dart';
part 'trips_state.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  TripsBloc({required GetTripsUseCase getTrips})
    : _getTrips = getTrips,
      super(const TripsLoading(TripFilter())) {
    on<TripsFilterChanged>(_onFilterChanged, transformer: restartable());
    on<TripsNextPageRequested>(_onNextPageRequested, transformer: droppable());
  }

  final GetTripsUseCase _getTrips;

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
    emit(TripsLoaded(current.filter, current.page, isLoadingMore: true));
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
          nextPageError: failure.message,
        ),
        (next) => TripsLoaded(latest.filter, latest.page.append(next)),
      ),
    );
  }
}
