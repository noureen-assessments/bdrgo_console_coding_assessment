import '../../../../shared/use_cases/use_case.dart';
import '../repositories/connectivity_repository.dart';

/// The current online status first, then every change.
class WatchConnectivityUseCase implements StreamUseCase<bool, NoParams> {
  const WatchConnectivityUseCase(this._repository);

  final ConnectivityRepository _repository;

  @override
  Stream<bool> call(NoParams params) async* {
    yield await _repository.isOnline();
    yield* _repository.watchOnline();
  }
}
