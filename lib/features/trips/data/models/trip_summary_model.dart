import '../../../../shared/models/money_model.dart';
import '../../domain/entities/trip_status.dart';
import '../../domain/entities/trip_summary.dart';


class TripSummaryModel extends TripSummary {
  const TripSummaryModel({
    required super.id,
    required super.status,
    required super.cityId,
    required super.cityName,
    required super.riderName,
    required super.driverName,
    required super.pickupAddress,
    required super.dropoffAddress,
    required MoneyModel super.fare,
    required MoneyModel super.refunded,
    required super.requestedAt,
  });

  factory TripSummaryModel.fromJson(Map<String, dynamic> json) {
    final driver = json['driver'] as Map<String, dynamic>?;
    return TripSummaryModel(
      id: json['id'] as String,
      status: TripStatus.fromValue(json['status'] as String),
      cityId: _field(json['city'], 'id'),
      cityName: _field(json['city'], 'name'),
      riderName: _field(json['rider'], 'name'),
      driverName: driver == null ? null : driver['name'] as String,
      pickupAddress: _field(json['pickup'], 'address'),
      dropoffAddress: _field(json['dropoff'], 'address'),
      fare: MoneyModel.fromJson(json['fare'] as Map<String, dynamic>),
      refunded: MoneyModel.fromJson(json['refunded'] as Map<String, dynamic>),
      requestedAt: DateTime.parse(json['requestedAt'] as String),
    );
  }

  static List<TripSummaryModel> listFromJson(List<dynamic> json) {
    final trips = <TripSummaryModel>[];
    for (final item in json) {
      trips.add(TripSummaryModel.fromJson(item as Map<String, dynamic>));
    }
    return trips;
  }

  static String _field(Object? json, String key) =>
      (json as Map<String, dynamic>)[key] as String;

  @override
  MoneyModel get fare => super.fare as MoneyModel;

  @override
  MoneyModel get refunded => super.refunded as MoneyModel;

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status.value,
    'city': {'id': cityId, 'name': cityName},
    'rider': {'name': riderName},
    'driver': driverName == null ? null : {'name': driverName},
    'pickup': {'address': pickupAddress},
    'dropoff': {'address': dropoffAddress},
    'fare': fare.toJson(),
    'refunded': refunded.toJson(),
    'requestedAt': requestedAt.toIso8601String(),
  };
}
