import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/kpi_range.dart';
import '../../../domain/entities/trip_series_point.dart';
import '../../../domain/usecases/get_trip_series_use_case.dart';

part 'trip_chart_event.dart';
part 'trip_chart_state.dart';

class TripChartBloc extends Bloc<TripChartEvent, TripChartState> {
  TripChartBloc({required GetTripSeriesUseCase getTripSeries})
    : _getTripSeries = getTripSeries,
      super(const TripChartLoading(KpiRange.last24Hours)) {
    on<TripChartRangeSelected>(_onRangeSelected, transformer: restartable());
  }

  final GetTripSeriesUseCase _getTripSeries;

  Future<void> _onRangeSelected(
    TripChartRangeSelected event,
    Emitter<TripChartState> emit,
  ) async {
    emit(TripChartLoading(event.range));
    final result = await _getTripSeries(event.range);
    emit(
      result.fold(
        (failure) => TripChartError(event.range, failure.message),
        (points) => TripChartLoaded(event.range, points),
      ),
    );
  }
}
