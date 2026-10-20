import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/kpi_range.dart';
import '../entities/kpis.dart';

abstract interface class DashboardRepository {
  Future<Either<Failure, Kpis>> getKpis(KpiRange range);
  Stream<Kpis> watchKpis();
  Stream<bool> watchLive();
}
