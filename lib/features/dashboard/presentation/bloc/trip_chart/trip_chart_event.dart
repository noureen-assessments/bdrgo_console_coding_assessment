part of 'trip_chart_bloc.dart';

sealed class TripChartEvent {
  const TripChartEvent();
}

final class TripChartRangeSelected extends TripChartEvent {
  const TripChartRangeSelected(this.range);

  final KpiRange range;
}
