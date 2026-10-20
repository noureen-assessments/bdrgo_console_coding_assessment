import 'package:equatable/equatable.dart';

import '../../../../shared/entities/money.dart';

class DriverTrip extends Equatable {
  const DriverTrip({
    required this.id,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.fare,
  });

  final String id;
  final String pickupAddress;
  final String dropoffAddress;
  final Money fare;

  @override
  List<Object?> get props => [id, pickupAddress, dropoffAddress, fare];
}
