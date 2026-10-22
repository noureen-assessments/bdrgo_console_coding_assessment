import 'package:equatable/equatable.dart';

import 'trip_status.dart';

class TripTimelineEntry extends Equatable {
  const TripTimelineEntry({required this.status, required this.at});

  final TripStatus status;
  final DateTime at;

  @override
  List<Object?> get props => [status, at];
}
