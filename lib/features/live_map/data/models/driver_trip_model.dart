import '../../../../shared/models/money_model.dart';
import '../../domain/entities/driver_trip.dart';

class DriverTripModel extends DriverTrip {
  const DriverTripModel({
    required super.id,
    required super.pickupAddress,
    required super.dropoffAddress,
    required MoneyModel super.fare,
  });

  factory DriverTripModel.fromJson(Map<String, dynamic> json) {
    final pickup = json['pickup'] as Map<String, dynamic>;
    final dropoff = json['dropoff'] as Map<String, dynamic>;
    return DriverTripModel(
      id: json['id'] as String,
      pickupAddress: pickup['address'] as String,
      dropoffAddress: dropoff['address'] as String,
      fare: MoneyModel.fromJson(json['fare'] as Map<String, dynamic>),
    );
  }

  @override
  MoneyModel get fare => super.fare as MoneyModel;

  Map<String, dynamic> toJson() => {
    'id': id,
    'pickup': {'address': pickupAddress},
    'dropoff': {'address': dropoffAddress},
    'fare': fare.toJson(),
  };
}
