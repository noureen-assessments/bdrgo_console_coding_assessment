import 'package:equatable/equatable.dart';

import 'driver_status.dart';
import 'driver_trip.dart';
import 'driver_vehicle.dart';

class DriverDetail extends Equatable {
  const DriverDetail({
    required this.id,
    required this.name,
    required this.phone,
    required this.rating,
    required this.status,
    required this.vehicle,
    required this.currentTrip,
  });

  final String id;
  final String name;
  final String phone;
  final double rating;
  final DriverStatus status;
  final DriverVehicle vehicle;
  final DriverTrip? currentTrip;

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    rating,
    status,
    vehicle,
    currentTrip,
  ];
}
