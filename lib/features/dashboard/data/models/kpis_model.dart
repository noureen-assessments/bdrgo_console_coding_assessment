import '../../../../shared/models/money_model.dart';
import '../../domain/entities/kpis.dart';
import 'driver_kpis_model.dart';
import 'trip_kpis_model.dart';


class KpisModel extends Kpis {
  const KpisModel({
    required super.generatedAt,
    required TripKpisModel super.trips,
    required DriverKpisModel super.drivers,
    required List<MoneyModel> super.revenue,
    required super.openAlerts,
  });

  factory KpisModel.fromJson(Map<String, dynamic> json) => KpisModel(
    generatedAt: DateTime.parse(json['generatedAt'] as String),
    trips: TripKpisModel.fromJson(json['trips'] as Map<String, dynamic>),
    drivers: DriverKpisModel.fromJson(json['drivers'] as Map<String, dynamic>),
    revenue: MoneyModel.listFromJson(json['revenue'] as List<dynamic>),
    openAlerts: (json['openAlerts'] as num).toInt(),
  );

  @override
  TripKpisModel get trips => super.trips as TripKpisModel;

  @override
  DriverKpisModel get drivers => super.drivers as DriverKpisModel;

  @override
  List<MoneyModel> get revenue => super.revenue as List<MoneyModel>;

  Map<String, dynamic> toJson() => {
    'generatedAt': generatedAt.toIso8601String(),
    'trips': trips.toJson(),
    'drivers': drivers.toJson(),
    'revenue': revenue.map((money) => money.toJson()).toList(),
    'openAlerts': openAlerts,
  };
}
