import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/safe_call.dart';
import '../../domain/entities/alert.dart';
import '../../domain/entities/alert_page.dart';
import '../../domain/entities/alert_page_request.dart';
import '../../domain/repositories/alerts_repository.dart';
import '../datasources/alerts_remote_data_source.dart';

final class AlertsRepositoryImpl implements AlertsRepository {
  const AlertsRepositoryImpl(this._remote);

  final AlertsRemoteDataSource _remote;

  @override
  Future<Either<Failure, AlertPage>> getAlerts(AlertPageRequest request) =>
      safeCall(() => _remote.fetchAlerts(request));

  @override
  Stream<Alert> watchAlerts() => _remote.watchAlerts();

  @override
  Stream<bool> watchLive() => _remote.watchLive();

  @override
  Future<Either<Failure, Alert>> acknowledge(String alertId) =>
      safeCall(() => _remote.acknowledge(alertId));
}
