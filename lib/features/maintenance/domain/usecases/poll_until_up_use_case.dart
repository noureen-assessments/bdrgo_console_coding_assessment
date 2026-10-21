import '../../../../shared/use_cases/use_case.dart';
import '../entities/maintenance_info.dart';
import '../repositories/maintenance_repository.dart';

class PollUntilUpUseCase
    implements StreamUseCase<MaintenanceInfo, MaintenanceInfo> {
  const PollUntilUpUseCase(this._repository);

  final MaintenanceRepository _repository;

  @override
  Stream<MaintenanceInfo> call(MaintenanceInfo params) =>
      _repository.pollUntilUp(params);
}
