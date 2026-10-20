import '../../domain/entities/trip_vehicle.dart';

class TripVehicleModel extends TripVehicle {
  const TripVehicleModel({
    required super.make,
    required super.model,
    required super.color,
    required super.plate,
  });

  factory TripVehicleModel.fromJson(Map<String, dynamic> json) =>
      TripVehicleModel(
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
