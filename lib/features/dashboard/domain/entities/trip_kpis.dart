import 'package:equatable/equatable.dart';


class TripKpis extends Equatable {
  const TripKpis({
    required this.active,
    required this.completed,
    required this.cancelled,
    required this.cancellationRate,
    required this.requested,
    required this.assigned,
    required this.inProgress,
  });

  final int active;
  final int completed;
  final int cancelled;

  final double cancellationRate;
  final int requested;
  final int assigned;
  final int inProgress;

  @override
  List<Object?> get props => [
    active,
    completed,
    cancelled,
    cancellationRate,
    requested,
    assigned,
    inProgress,
  ];
}
