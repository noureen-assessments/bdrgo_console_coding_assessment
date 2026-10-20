import '../../../../shared/use_cases/use_case.dart';
import '../entities/kpis.dart';
import '../repositories/dashboard_repository.dart';

class WatchKpisUseCase implements StreamUseCase<Kpis, NoParams> {
  const WatchKpisUseCase(this._repository);

  final DashboardRepository _repository;

  @override
  Stream<Kpis> call(NoParams params) => _repository.watchKpis();
}
