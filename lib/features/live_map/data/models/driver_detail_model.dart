import '../../domain/entities/driver_detail.dart';
import '../../domain/entities/driver_status.dart';
import 'driver_trip_model.dart';
import 'driver_vehicle_model.dart';

class DriverDetailModel extends DriverDetail {
  const DriverDetailModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.rating,
    required super.status,
    required DriverVehicleModel super.vehicle,
    required DriverTripModel? super.currentTrip,
  });

  factory DriverDetailModel.fromJson(Map<String, dynamic> json) {
    final trip = json['currentTrip'] as Map<String, dynamic>?;
    DriverTripModel? currentTrip;
    if (trip != null) {
      currentTrip = DriverTripModel.fromJson(trip);
    }
    return DriverDetailModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      rating: (json['rating'] as num).toDouble(),
      status: DriverStatus.fromValue(json['status'] as String),
      vehicle: DriverVehicleModel.fromJson(
        json['vehicle'] as Map<String, dynamic>,
      ),
      currentTrip: currentTrip,
    );
  }

  @override
  DriverVehicleModel get vehicle => super.vehicle as DriverVehicleModel;

  @override
  DriverTripModel? get currentTrip => super.currentTrip as DriverTripModel?;

  Map<String, dynamic> toJson() {
    final trip = currentTrip;
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'rating': rating,
      'status': status.value,
      'vehicle': vehicle.toJson(),
      'currentTrip': trip == null ? null : trip.toJson(),
    };
  }
}
