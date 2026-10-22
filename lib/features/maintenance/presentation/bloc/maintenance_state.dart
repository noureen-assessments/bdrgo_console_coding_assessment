part of 'maintenance_bloc.dart';

sealed class MaintenanceState extends Equatable {
  const MaintenanceState();

  @override
  List<Object?> get props => [];
}

final class MaintenanceOff extends MaintenanceState {
  const MaintenanceOff();
}

final class MaintenanceOn extends MaintenanceState {
  const MaintenanceOn(this.info);

  final MaintenanceInfo info;

  @override
  List<Object?> get props => [info];
}
