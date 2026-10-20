import '../../domain/entities/trip_detail.dart';
import 'trip_summary_model.dart';
import 'trip_timeline_entry_model.dart';
import 'trip_vehicle_model.dart';

class TripDetailModel extends TripDetail {
  const TripDetailModel({
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
    required super.riderPhone,
    required super.riderEmail,
    required super.riderRating,
    required super.driverPhone,
    required super.driverRating,
    required TripVehicleModel? super.vehicle,
    required super.distanceKm,
    required super.refundReason,
    required super.cancelReason,
    required super.cancelledBy,
    required List<TripTimelineEntryModel> super.timeline,
  });

  factory TripDetailModel.fromJson(Map<String, dynamic> json) {
    final row = TripSummaryModel.fromJson(json);
    final rider = json['rider'] as Map<String, dynamic>;
    final driver = json['driver'] as Map<String, dynamic>?;
    final vehicle = driver == null
        ? null
        : driver['vehicle'] as Map<String, dynamic>?;
    return TripDetailModel(
      id: row.id,
      status: row.status,
      cityId: row.cityId,
      cityName: row.cityName,
      riderName: row.riderName,
      driverName: row.driverName,
      pickupAddress: row.pickupAddress,
      dropoffAddress: row.dropoffAddress,
      fare: row.fare,
      refunded: row.refunded,
      requestedAt: row.requestedAt,
      riderPhone: rider['phone'] as String,
      riderEmail: rider['email'] as String?,
      riderRating: (rider['rating'] as num).toDouble(),
      driverPhone: driver == null ? null : driver['phone'] as String,
      driverRating: driver == null
          ? null
          : (driver['rating'] as num).toDouble(),
      vehicle: vehicle == null ? null : TripVehicleModel.fromJson(vehicle),
      distanceKm: (json['distanceKm'] as num).toDouble(),
      refundReason: json['refundReason'] as String?,
      cancelReason: json['cancelReason'] as String?,
      cancelledBy: json['cancelledBy'] as String?,
      timeline: TripTimelineEntryModel.listFromJson(
        json['timeline'] as List<dynamic>,
      ),
    );
  }
}
