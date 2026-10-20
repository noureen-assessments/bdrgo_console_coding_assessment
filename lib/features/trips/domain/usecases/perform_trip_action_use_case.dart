import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/trip_action.dart';
import '../repositories/trips_repository.dart';

class PerformTripActionUseCase implements UseCase<Unit, TripAction> {
  const PerformTripActionUseCase(this._repository);

  final TripsRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(TripAction params) =>
      _repository.perform(params);
}
