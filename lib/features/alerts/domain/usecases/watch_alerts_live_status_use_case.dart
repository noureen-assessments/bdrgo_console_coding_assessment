import '../../../../shared/use_cases/use_case.dart';
import '../repositories/alerts_repository.dart';

class WatchAlertsLiveStatusUseCase implements StreamUseCase<bool, NoParams> {
  const WatchAlertsLiveStatusUseCase(this._repository);

  final AlertsRepository _repository;

  @override
  Stream<bool> call(NoParams params) => _repository.watchLive();
}
