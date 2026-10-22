import 'package:equatable/equatable.dart';

class TripVehicle extends Equatable {
  const TripVehicle({
    required this.make,
    required this.model,
    required this.color,
    required this.plate,
  });

  final String make;
  final String model;
  final String color;
  final String plate;

  @override
  List<Object?> get props => [make, model, color, plate];
}
