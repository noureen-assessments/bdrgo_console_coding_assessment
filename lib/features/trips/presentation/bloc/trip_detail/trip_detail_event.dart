part of 'trip_detail_bloc.dart';

sealed class TripDetailEvent {
  const TripDetailEvent();
}

final class TripDetailStarted extends TripDetailEvent {
  const TripDetailStarted(this.tripId);

  final String tripId;
}

final class TripDetailRequested extends TripDetailEvent {
  const TripDetailRequested(this.tripId);

  final String tripId;
}
