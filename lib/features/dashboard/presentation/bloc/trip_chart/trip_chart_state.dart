part of 'trip_chart_bloc.dart';

sealed class TripChartState extends Equatable {
  const TripChartState(this.range);

  final KpiRange range;

  @override
  List<Object?> get props => [range];
}

final class TripChartLoading extends TripChartState {
  const TripChartLoading(super.range);
}

final class TripChartError extends TripChartState {
  const TripChartError(super.range, this.message);

  final String message;

  @override
  List<Object?> get props => [range, message];
}

final class TripChartLoaded extends TripChartState {
  const TripChartLoaded(super.range, this.points);

  final List<TripSeriesPoint> points;

  @override
  List<Object?> get props => [range, points];
}
