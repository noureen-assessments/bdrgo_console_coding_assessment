import '../../../../shared/use_cases/use_case.dart';
import '../entities/maintenance_info.dart';
import '../repositories/maintenance_repository.dart';

class WatchMaintenanceUseCase
    implements StreamUseCase<MaintenanceInfo, NoParams> {
  const WatchMaintenanceUseCase(this._repository);

  final MaintenanceRepository _repository;

  @override
  Stream<MaintenanceInfo> call(NoParams params) =>
      _repository.watchMaintenance();
}
