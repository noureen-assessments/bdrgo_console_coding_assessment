import '../../domain/entities/driver_vehicle.dart';

class DriverVehicleModel extends DriverVehicle {
  const DriverVehicleModel({
    required super.make,
    required super.model,
    required super.color,
    required super.plate,
  });

  factory DriverVehicleModel.fromJson(Map<String, dynamic> json) =>
      DriverVehicleModel(
        make: json['make'] as String,
        model: json['model'] as String,
        color: json['color'] as String,
        plate: json['plate'] as String,
      );

  Map<String, dynamic> toJson() => {
    'make': make,
    'model': model,
    'color': color,
    'plate': plate,
  };
}
