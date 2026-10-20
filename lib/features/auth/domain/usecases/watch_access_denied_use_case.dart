import '../../../../shared/use_cases/use_case.dart';
import '../repositories/auth_repository.dart';

/// Emits whenever any transport rejects a request with a `403`.
class WatchAccessDeniedUseCase implements StreamUseCase<void, NoParams> {
  const WatchAccessDeniedUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Stream<void> call(NoParams params) => _repository.watchAccessDenied();
}
