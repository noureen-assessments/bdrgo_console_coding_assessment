part of 'trip_detail_bloc.dart';

sealed class TripDetailEvent {
  const TripDetailEvent();
}

final class TripDetailRequested extends TripDetailEvent {
  const TripDetailRequested(this.tripId);

  final String tripId;
}
