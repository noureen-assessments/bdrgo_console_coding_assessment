import '../../../../shared/use_cases/use_case.dart';
import '../repositories/dashboard_repository.dart';

class WatchLiveStatusUseCase implements StreamUseCase<bool, NoParams> {
  const WatchLiveStatusUseCase(this._repository);

  final DashboardRepository _repository;

  @override
  Stream<bool> call(NoParams params) => _repository.watchLive();
}
