import 'package:equatable/equatable.dart';

import '../../../../shared/entities/money.dart';
import 'trip_action_rules.dart';
import 'trip_status.dart';


class TripSummary extends Equatable {
  const TripSummary({
    required this.id,
    required this.status,
    required this.cityId,
    required this.cityName,
    required this.riderName,
    required this.driverName,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.fare,
    required this.refunded,
    required this.requestedAt,
  });

  final String id;
  final TripStatus status;
  final String cityId;
  final String cityName;
  final String riderName;

  final String? driverName;
  final String pickupAddress;
  final String dropoffAddress;
  final Money fare;
  final Money refunded;
  final DateTime requestedAt;

  // status number.
  bool isOlderThan(TripSummary other) => status.index < other.status.index;

  double get remainingRefund =>
      ((fare.amount - refunded.amount) * 100).round() / 100;

  bool get canAssign => TripActionRules.assignFrom.contains(status);

  bool get canCancel => TripActionRules.cancelFrom.contains(status);

  bool get canRefund => TripActionRules.refundFrom.contains(status) && remainingRefund > 0;

  @override
  List<Object?> get props => [
    id,
    status,
    cityId,
    cityName,
    riderName,
    driverName,
    pickupAddress,
    dropoffAddress,
    fare,
    refunded,
    requestedAt,
  ];
}
