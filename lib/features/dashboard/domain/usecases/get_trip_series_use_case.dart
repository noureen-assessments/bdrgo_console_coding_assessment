import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/kpi_range.dart';
import '../entities/trip_series_point.dart';
import '../repositories/dashboard_repository.dart';

class GetTripSeriesUseCase implements UseCase<List<TripSeriesPoint>, KpiRange> {
  const GetTripSeriesUseCase(this._repository);

  final DashboardRepository _repository;

  @override
  Future<Either<Failure, List<TripSeriesPoint>>> call(KpiRange params) =>
      _repository.getTripSeries(params);
}
