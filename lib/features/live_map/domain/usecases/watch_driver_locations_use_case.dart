import '../../../../shared/use_cases/use_case.dart';
import '../entities/driver_location.dart';
import '../repositories/live_map_repository.dart';

class WatchDriverLocationsUseCase
    implements StreamUseCase<List<DriverLocation>, NoParams> {
  const WatchDriverLocationsUseCase(this._repository);

  final LiveMapRepository _repository;

  @override
  Stream<List<DriverLocation>> call(NoParams params) =>
      _repository.watchDriverLocations();
}
