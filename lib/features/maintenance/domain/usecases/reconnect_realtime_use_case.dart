import '../../../../shared/use_cases/use_case.dart';
import '../repositories/maintenance_repository.dart';

class ReconnectRealtimeUseCase {
  const ReconnectRealtimeUseCase(this._repository);

  final MaintenanceRepository _repository;

  void call(NoParams params) => _repository.reconnectRealtime();
}
