import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/available_driver.dart';
import '../repositories/trips_repository.dart';

class GetAvailableDriversUseCase
    implements UseCase<List<AvailableDriver>, String> {
  const GetAvailableDriversUseCase(this._repository);

  final TripsRepository _repository;

  @override
  Future<Either<Failure, List<AvailableDriver>>> call(String params) =>
      _repository.getAvailableDrivers(params);
}
