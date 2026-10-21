import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/alert.dart';
import '../repositories/alerts_repository.dart';

class AcknowledgeAlertUseCase implements UseCase<Alert, String> {
  const AcknowledgeAlertUseCase(this._repository);

  final AlertsRepository _repository;

  @override
  Future<Either<Failure, Alert>> call(String params) =>
      _repository.acknowledge(params);
}
