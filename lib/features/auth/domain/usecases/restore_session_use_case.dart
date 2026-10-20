import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/current_user.dart';
import '../repositories/auth_repository.dart';

class RestoreSessionUseCase implements UseCase<CurrentUser?, NoParams> {
  const RestoreSessionUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, CurrentUser?>> call(NoParams params) =>
      _repository.restoreSession();
}
