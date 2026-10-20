import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/trip_summary.dart';
import '../repositories/trips_repository.dart';

class GetTripUseCase implements UseCase<TripSummary?, String> {
  const GetTripUseCase(this._repository);

  final TripsRepository _repository;

  @override
  Future<Either<Failure, TripSummary?>> call(String params) =>
      _repository.getTrip(params);
}
