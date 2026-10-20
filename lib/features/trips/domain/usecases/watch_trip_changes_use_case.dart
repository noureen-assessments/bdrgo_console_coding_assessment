import '../../../../shared/use_cases/use_case.dart';
import '../entities/trip_change.dart';
import '../repositories/trips_repository.dart';

class WatchTripChangesUseCase implements StreamUseCase<TripChange, NoParams> {
  const WatchTripChangesUseCase(this._repository);

  final TripsRepository _repository;

  @override
  Stream<TripChange> call(NoParams params) => _repository.watchTripChanges();
}
