import '../../../../shared/use_cases/use_case.dart';
import '../repositories/live_map_repository.dart';

class WatchMapLiveStatusUseCase implements StreamUseCase<bool, NoParams> {
  const WatchMapLiveStatusUseCase(this._repository);

  final LiveMapRepository _repository;

  @override
  Stream<bool> call(NoParams params) => _repository.watchLive();
}
