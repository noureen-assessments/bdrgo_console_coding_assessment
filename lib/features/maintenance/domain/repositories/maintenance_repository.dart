import '../entities/maintenance_info.dart';

abstract interface class MaintenanceRepository {
  Stream<MaintenanceInfo> watchMaintenance();
  Stream<MaintenanceInfo> pollUntilUp(MaintenanceInfo info);
  void reconnectRealtime();
}
