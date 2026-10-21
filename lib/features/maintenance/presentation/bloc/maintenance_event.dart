part of 'maintenance_bloc.dart';

sealed class MaintenanceEvent {
  const MaintenanceEvent();
}

final class MaintenanceStarted extends MaintenanceEvent {
  const MaintenanceStarted();
}

final class MaintenanceDetected extends MaintenanceEvent {
  const MaintenanceDetected(this.info);

  final MaintenanceInfo info;
}
