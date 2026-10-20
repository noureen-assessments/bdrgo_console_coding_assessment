import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/trip_detail.dart';
import '../repositories/trips_repository.dart';

class GetTripDetailUseCase implements UseCase<TripDetail?, String> {
  const GetTripDetailUseCase(this._repository);

  final TripsRepository _repository;

  @override
  Future<Either<Failure, TripDetail?>> call(String params) =>
      _repository.getTripDetail(params);
}
