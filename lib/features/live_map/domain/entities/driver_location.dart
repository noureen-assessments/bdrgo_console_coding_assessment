import 'package:equatable/equatable.dart';

import 'driver_status.dart';

class DriverLocation extends Equatable {
  const DriverLocation({
    required this.id,
    required this.name,
    required this.status,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String name;
  final DriverStatus status;
  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => [id, name, status, latitude, longitude];
}
