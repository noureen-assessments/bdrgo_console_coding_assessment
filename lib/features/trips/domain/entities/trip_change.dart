import 'package:equatable/equatable.dart';

import 'trip_status.dart';


class TripChange extends Equatable {
  const TripChange({required this.tripId, required this.status});

  final String tripId;

  final TripStatus status;

  @override
  List<Object?> get props => [tripId, status];
}
