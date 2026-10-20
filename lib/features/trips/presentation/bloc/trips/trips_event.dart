part of 'trips_bloc.dart';

sealed class TripsEvent {
  const TripsEvent();
}

final class TripsLoadRequested extends TripsEvent {
  const TripsLoadRequested();
}

final class TripsNextPageRequested extends TripsEvent {
  const TripsNextPageRequested();
}
