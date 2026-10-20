import '../../domain/entities/trip_kpis.dart';


class TripKpisModel extends TripKpis {
  const TripKpisModel({
    required super.active,
    required super.completed,
    required super.cancelled,
    required super.cancellationRate,
    required super.requested,
    required super.assigned,
    required super.inProgress,
  });

  factory TripKpisModel.fromJson(Map<String, dynamic> json) => TripKpisModel(
    active: (json['active'] as num).toInt(),
    completed: (json['completed'] as num).toInt(),
    cancelled: (json['cancelled'] as num).toInt(),
    cancellationRate: (json['cancellationRate'] as num).toDouble(),
    requested: (json['requested'] as num).toInt(),
    assigned: (json['assigned'] as num).toInt(),
    inProgress: (json['inProgress'] as num).toInt(),
  );

  Map<String, dynamic> toJson() => {
    'active': active,
    'completed': completed,
    'cancelled': cancelled,
    'cancellationRate': cancellationRate,
    'requested': requested,
    'assigned': assigned,
    'inProgress': inProgress,
  };
}
