import '../../domain/entities/alert.dart';
import '../../domain/entities/alert_severity.dart';
import '../../domain/entities/alert_type.dart';

class AlertModel extends Alert {
  const AlertModel({
    required super.id,
    required super.cityId,
    required super.type,
    required super.severity,
    required super.message,
    required super.tripId,
    required super.driverId,
    required super.createdAt,
    required super.acknowledgedAt,
    required super.acknowledgedBy,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    final acknowledgedAt = json['acknowledgedAt'] as String?;
    return AlertModel(
      id: json['id'] as String,
      cityId: json['cityId'] as String,
      type: AlertType.fromValue(json['type'] as String),
      severity: AlertSeverity.fromValue(json['severity'] as String),
      message: json['message'] as String,
      tripId: json['tripId'] as String?,
      driverId: json['driverId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      acknowledgedAt: acknowledgedAt == null
          ? null
          : DateTime.parse(acknowledgedAt),
      acknowledgedBy: json['acknowledgedBy'] as String?,
    );
  }

  static List<AlertModel> listFromJson(List<dynamic> json) {
    final alerts = <AlertModel>[];
    for (final item in json) {
      alerts.add(AlertModel.fromJson(item as Map<String, dynamic>));
    }
    return alerts;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'cityId': cityId,
    'type': type.value,
    'severity': severity.value,
    'message': message,
    'tripId': tripId,
    'driverId': driverId,
    'createdAt': createdAt.toIso8601String(),
    'acknowledgedAt': acknowledgedAt?.toIso8601String(),
    'acknowledgedBy': acknowledgedBy,
  };
}
