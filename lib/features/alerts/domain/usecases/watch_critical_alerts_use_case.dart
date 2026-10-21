import '../../../../shared/use_cases/use_case.dart';
import '../entities/alert.dart';
import '../repositories/alerts_repository.dart';

class WatchCriticalAlertsUseCase implements StreamUseCase<Alert, NoParams> {
  const WatchCriticalAlertsUseCase(this._repository);

  final AlertsRepository _repository;

  @override
  Stream<Alert> call(NoParams params) =>
      _repository.watchAlerts().where((alert) => alert.isCritical);
}
