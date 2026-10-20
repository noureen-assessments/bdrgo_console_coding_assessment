import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/trip_page.dart';
import '../entities/trip_page_request.dart';

abstract interface class TripsRepository {
  Future<Either<Failure, TripPage>> getTrips(TripPageRequest request);
}
