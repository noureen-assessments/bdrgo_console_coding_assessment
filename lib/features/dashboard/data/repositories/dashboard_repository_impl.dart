import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/kpi_range.dart';
import '../../domain/entities/kpis.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

final class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(this._remote);

  final DashboardRemoteDataSource _remote;

  @override
  Future<Either<Failure, Kpis>> getKpis(KpiRange range) =>
      safeCall(() => _remote.fetchKpis(range));

  @override
  Stream<Kpis> watchKpis() => _remote.watchKpis();

  @override
  Stream<bool> watchLive() => _remote.watchLive();
}
