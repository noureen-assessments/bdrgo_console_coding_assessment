part of 'trips_bloc.dart';

sealed class TripsEvent {
  const TripsEvent();
}

final class TripsFilterChanged extends TripsEvent {
  const TripsFilterChanged(this.filter);

  final TripFilter filter;
}

final class TripsNextPageRequested extends TripsEvent {
  const TripsNextPageRequested();
}
