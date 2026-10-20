import '../../../../shared/use_cases/use_case.dart';
import '../repositories/auth_repository.dart';

class WatchSessionExpiryUseCase implements StreamUseCase<void, NoParams> {
  const WatchSessionExpiryUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Stream<void> call(NoParams params) => _repository.watchSessionExpiry();
}
