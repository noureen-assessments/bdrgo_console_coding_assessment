import 'package:equatable/equatable.dart';

class DriverKpis extends Equatable {
  const DriverKpis({
    required this.available,
    required this.onTrip,
    required this.offline,
    required this.total,
  });

  final int available;
  final int onTrip;
  final int offline;
  final int total;

  @override
  List<Object?> get props => [available, onTrip, offline, total];
}
