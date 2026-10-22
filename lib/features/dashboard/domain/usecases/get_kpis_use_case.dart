import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/kpi_range.dart';
import '../entities/kpis.dart';
import '../repositories/dashboard_repository.dart';

class GetKpisUseCase implements UseCase<Kpis, KpiRange> {
  const GetKpisUseCase(this._repository);

  final DashboardRepository _repository;

  @override
  Future<Either<Failure, Kpis>> call(KpiRange params) =>
      _repository.getKpis(params);
}
