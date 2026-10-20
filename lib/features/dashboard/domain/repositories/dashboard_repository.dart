import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/kpi_range.dart';
import '../entities/kpis.dart';
import '../entities/trip_series_point.dart';

abstract interface class DashboardRepository {
  Future<Either<Failure, Kpis>> getKpis(KpiRange range);
  Future<Either<Failure, List<TripSeriesPoint>>> getTripSeries(KpiRange range);
  Stream<Kpis> watchKpis();
  Stream<bool> watchLive();
}
