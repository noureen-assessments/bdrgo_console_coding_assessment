import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/available_driver.dart';
import '../../domain/entities/trip_action.dart';
import '../../domain/entities/trip_change.dart';
import '../../domain/entities/trip_detail.dart';
import '../../domain/entities/trip_page.dart';
import '../../domain/entities/trip_page_request.dart';
import '../../domain/entities/trip_summary.dart';
import '../../domain/repositories/trips_repository.dart';
import '../datasources/trips_remote_data_source.dart';

final class TripsRepositoryImpl implements TripsRepository {
  const TripsRepositoryImpl(this._remote);

  final TripsRemoteDataSource _remote;

  @override
  Future<Either<Failure, TripPage>> getTrips(TripPageRequest request) =>
      safeCall(() => _remote.fetchTrips(request));

  @override
  Future<Either<Failure, TripSummary?>> getTrip(String id) =>
      safeCall(() => _remote.fetchTrip(id));

  @override
  Future<Either<Failure, TripDetail?>> getTripDetail(String id) =>
      safeCall(() => _remote.fetchTripDetail(id));

  @override
  Stream<TripChange> watchTripChanges() => _remote.watchTripChanges();

  @override
  Future<Either<Failure, Unit>> perform(TripAction action) async {
    final result = await safeCall(() => _remote.perform(action));
    return result.map((_) => unit);
  }

  @override
  Future<Either<Failure, List<AvailableDriver>>> getAvailableDrivers(
    String cityId,
  ) => safeCall(() => _remote.fetchAvailableDrivers(cityId));
}
