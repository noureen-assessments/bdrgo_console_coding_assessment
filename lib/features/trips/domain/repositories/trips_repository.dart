import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/available_driver.dart';
import '../entities/trip_action.dart';
import '../entities/trip_change.dart';
import '../entities/trip_page.dart';
import '../entities/trip_page_request.dart';
import '../entities/trip_summary.dart';

abstract interface class TripsRepository {
  Future<Either<Failure, TripPage>> getTrips(TripPageRequest request);
  Future<Either<Failure, TripSummary?>> getTrip(String id);
  Stream<TripChange> watchTripChanges();
  Future<Either<Failure, Unit>> perform(TripAction action);
  Future<Either<Failure, List<AvailableDriver>>> getAvailableDrivers(
    String cityId,
  );
}
