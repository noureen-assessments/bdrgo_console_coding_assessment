import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/trip_page.dart';
import '../entities/trip_page_request.dart';
import '../repositories/trips_repository.dart';

class GetTripsUseCase implements UseCase<TripPage, TripPageRequest> {
  const GetTripsUseCase(this._repository);

  final TripsRepository _repository;

  @override
  Future<Either<Failure, TripPage>> call(TripPageRequest params) =>
      _repository.getTrips(params);
}
