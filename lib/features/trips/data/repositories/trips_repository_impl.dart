import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/trip_page.dart';
import '../../domain/entities/trip_page_request.dart';
import '../../domain/repositories/trips_repository.dart';
import '../datasources/trips_remote_data_source.dart';

final class TripsRepositoryImpl implements TripsRepository {
  const TripsRepositoryImpl(this._remote);

  final TripsRemoteDataSource _remote;

  @override
  Future<Either<Failure, TripPage>> getTrips(TripPageRequest request) =>
      safeCall(() => _remote.fetchTrips(request));
}
