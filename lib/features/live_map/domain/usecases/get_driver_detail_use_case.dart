import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/use_cases/use_case.dart';
import '../entities/driver_detail.dart';
import '../repositories/live_map_repository.dart';

class GetDriverDetailUseCase implements UseCase<DriverDetail?, String> {
  const GetDriverDetailUseCase(this._repository);

  final LiveMapRepository _repository;

  @override
  Future<Either<Failure, DriverDetail?>> call(String params) =>
      _repository.getDriverDetail(params);
}
