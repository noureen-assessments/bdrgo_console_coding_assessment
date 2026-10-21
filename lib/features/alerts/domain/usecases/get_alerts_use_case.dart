import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/alert_page.dart';
import '../entities/alert_page_request.dart';
import '../repositories/alerts_repository.dart';

class GetAlertsUseCase implements UseCase<AlertPage, AlertPageRequest> {
  const GetAlertsUseCase(this._repository);

  final AlertsRepository _repository;

  @override
  Future<Either<Failure, AlertPage>> call(AlertPageRequest params) =>
      _repository.getAlerts(params);
}
