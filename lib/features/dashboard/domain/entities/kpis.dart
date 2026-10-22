import 'package:equatable/equatable.dart';

import '../../../../shared/entities/money.dart';
import 'driver_kpis.dart';
import 'trip_kpis.dart';


class Kpis extends Equatable {
  const Kpis({
    required this.generatedAt,
    required this.trips,
    required this.drivers,
    required this.revenue,
    required this.openAlerts,
  });


  final DateTime generatedAt;
  final TripKpis trips;
  final DriverKpis drivers;


  final List<Money> revenue;
  final int openAlerts;

  bool isOlderThan(Kpis other) => generatedAt.isBefore(other.generatedAt);

  @override
  List<Object?> get props => [generatedAt, trips, drivers, revenue, openAlerts];
}
