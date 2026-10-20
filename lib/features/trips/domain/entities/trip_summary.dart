import 'package:equatable/equatable.dart';

import '../../../../shared/entities/money.dart';
import 'trip_status.dart';


class TripSummary extends Equatable {
  const TripSummary({
    required this.id,
    required this.status,
    required this.cityName,
    required this.riderName,
    required this.driverName,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.fare,
    required this.requestedAt,
  });

  final String id;
  final TripStatus status;
  final String cityName;
  final String riderName;

  final String? driverName;
  final String pickupAddress;
  final String dropoffAddress;
  final Money fare;
  final DateTime requestedAt;

  /// A status never goes back, so a copy with an earlier status is stale
  /// (e.g. a slow answer that lands after a newer one).
  bool isOlderThan(TripSummary other) => status.index < other.status.index;

  @override
  List<Object?> get props => [
    id,
    status,
    cityName,
    riderName,
    driverName,
    pickupAddress,
    dropoffAddress,
    fare,
    requestedAt,
  ];
}
