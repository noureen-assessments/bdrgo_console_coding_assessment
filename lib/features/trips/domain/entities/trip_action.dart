import 'package:equatable/equatable.dart';


sealed class TripAction extends Equatable {
  const TripAction(this.tripId);

  final String tripId;

  @override
  List<Object?> get props => [tripId];
}

final class AssignDriver extends TripAction {
  const AssignDriver(super.tripId, {required this.driverId});

  final String driverId;

  @override
  List<Object?> get props => [tripId, driverId];
}

final class CancelTrip extends TripAction {
  const CancelTrip(super.tripId, {required this.reason});

  final String reason;

  @override
  List<Object?> get props => [tripId, reason];
}

final class RefundTrip extends TripAction {
  const RefundTrip(super.tripId, {required this.amount, required this.reason});

  final double amount;
  final String reason;

  @override
  List<Object?> get props => [tripId, amount, reason];
}
