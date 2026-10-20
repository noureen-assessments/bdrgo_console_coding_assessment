import '../../../../shared/use_cases/use_case.dart';
import '../repositories/auth_repository.dart';

/// Emits whenever any transport rejects the session with a `401`.
class WatchSessionExpiryUseCase implements StreamUseCase<void, NoParams> {
  const WatchSessionExpiryUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Stream<void> call(NoParams params) => _repository.watchSessionExpiry();
}
