import 'package:equatable/equatable.dart';

import 'alert_severity.dart';
import 'alert_type.dart';

class Alert extends Equatable {
  const Alert({
    required this.id,
    required this.cityId,
    required this.type,
    required this.severity,
    required this.message,
    required this.tripId,
    required this.driverId,
    required this.createdAt,
    required this.acknowledgedAt,
    required this.acknowledgedBy,
  });

  final String id;
  final String cityId;
  final AlertType type;
  final AlertSeverity severity;
  final String message;
  final String? tripId;
  final String? driverId;
  final DateTime createdAt;
  final DateTime? acknowledgedAt;
  final String? acknowledgedBy;

  bool get isAcknowledged => acknowledgedAt != null;

  @override
  List<Object?> get props => [
    id,
    cityId,
    type,
    severity,
    message,
    tripId,
    driverId,
    createdAt,
    acknowledgedAt,
    acknowledgedBy,
  ];
}
