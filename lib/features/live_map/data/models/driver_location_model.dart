import '../../domain/entities/driver_location.dart';
import '../../domain/entities/driver_status.dart';

class DriverLocationModel extends DriverLocation {
  const DriverLocationModel({
    required super.id,
    required super.name,
    required super.status,
    required super.latitude,
    required super.longitude,
  });

  factory DriverLocationModel.fromJson(Map<String, dynamic> json) =>
      DriverLocationModel(
        id: json['id'] as String,
        name: json['name'] as String,
        status: DriverStatus.fromValue(json['status'] as String),
        latitude: (json['lat'] as num).toDouble(),
        longitude: (json['lng'] as num).toDouble(),
      );

  static List<DriverLocationModel> listFromJson(List<dynamic> json) {
    final drivers = <DriverLocationModel>[];
    for (final item in json) {
      drivers.add(DriverLocationModel.fromJson(item as Map<String, dynamic>));
    }
    return drivers;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'status': status.value,
    'lat': latitude,
    'lng': longitude,
  };
}
