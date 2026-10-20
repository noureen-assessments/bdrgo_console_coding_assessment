import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/driver_detail.dart';
import '../entities/driver_location.dart';

abstract interface class LiveMapRepository {
  Stream<List<DriverLocation>> watchDriverLocations();
  Stream<bool> watchLive();
  Future<Either<Failure, DriverDetail?>> getDriverDetail(String id);
}
