import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/driver_detail.dart';
import '../../domain/entities/driver_location.dart';
import '../../domain/repositories/live_map_repository.dart';
import '../datasources/live_map_remote_data_source.dart';

final class LiveMapRepositoryImpl implements LiveMapRepository {
  const LiveMapRepositoryImpl(this._remote);

  final LiveMapRemoteDataSource _remote;

  @override
  Stream<List<DriverLocation>> watchDriverLocations() =>
      _remote.watchDriverLocations();

  @override
  Stream<bool> watchLive() => _remote.watchLive();

  @override
  Future<Either<Failure, DriverDetail?>> getDriverDetail(String id) =>
      safeCall(() => _remote.fetchDriverDetail(id));
}
