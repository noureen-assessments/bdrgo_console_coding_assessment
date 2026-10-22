part of 'trips_bloc.dart';

sealed class TripsEvent {
  const TripsEvent();
}

final class TripsStarted extends TripsEvent {
  const TripsStarted();
}

final class TripsFilterChanged extends TripsEvent {
  const TripsFilterChanged(this.filter);

  final TripFilter filter;
}

final class TripsRefreshRequested extends TripsEvent {
  const TripsRefreshRequested();
}

final class TripsNextPageRequested extends TripsEvent {
  const TripsNextPageRequested();
}

final class TripsTripChanged extends TripsEvent {
  const TripsTripChanged(this.change);

  final TripChange change;
}
