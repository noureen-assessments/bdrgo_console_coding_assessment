import 'trip_summary.dart';
import 'trip_timeline_entry.dart';
import 'trip_vehicle.dart';

class TripDetail extends TripSummary {
  const TripDetail({
    required super.id,
    required super.status,
    required super.cityId,
    required super.cityName,
    required super.riderName,
    required super.driverName,
    required super.pickupAddress,
    required super.dropoffAddress,
    required super.fare,
    required super.refunded,
    required super.requestedAt,
    required this.riderPhone,
    required this.riderEmail,
    required this.riderRating,
    required this.driverPhone,
    required this.driverRating,
    required this.vehicle,
    required this.distanceKm,
    required this.refundReason,
    required this.cancelReason,
    required this.cancelledBy,
    required this.timeline,
  });

  final String riderPhone;
  final String? riderEmail;
  final double riderRating;
  final String? driverPhone;
  final double? driverRating;
  final TripVehicle? vehicle;
  final double distanceKm;
  final String? refundReason;
  final String? cancelReason;
  final String? cancelledBy;
  final List<TripTimelineEntry> timeline;

  @override
  List<Object?> get props => [
    ...super.props,
    riderPhone,
    riderEmail,
    riderRating,
    driverPhone,
    driverRating,
    vehicle,
    distanceKm,
    refundReason,
    cancelReason,
    cancelledBy,
    timeline,
  ];
}
