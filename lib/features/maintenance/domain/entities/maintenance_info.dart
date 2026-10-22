import 'package:equatable/equatable.dart';

import 'maintenance_reason.dart';

class MaintenanceInfo extends Equatable {
  const MaintenanceInfo({
    required this.message,
    required this.reason,
    required this.since,
    required this.retryAfter,
  });

  final String message;
  final MaintenanceReason reason;
  final DateTime? since;
  final Duration? retryAfter;

  @override
  List<Object?> get props => [message, reason, since, retryAfter];
}
