import '../../domain/entities/driver_kpis.dart';


class DriverKpisModel extends DriverKpis {
  const DriverKpisModel({
    required super.available,
    required super.onTrip,
    required super.offline,
    required super.total,
  });

  factory DriverKpisModel.fromJson(Map<String, dynamic> json) =>
      DriverKpisModel(
        available: (json['available'] as num).toInt(),
        onTrip: (json['onTrip'] as num).toInt(),
        offline: (json['offline'] as num).toInt(),
        total: (json['total'] as num).toInt(),
      );

  Map<String, dynamic> toJson() => {
    'available': available,
    'onTrip': onTrip,
    'offline': offline,
    'total': total,
  };
}
