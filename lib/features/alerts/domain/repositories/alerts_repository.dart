import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/alert.dart';
import '../entities/alert_page.dart';
import '../entities/alert_page_request.dart';

abstract interface class AlertsRepository {
  Future<Either<Failure, AlertPage>> getAlerts(AlertPageRequest request);
  Stream<Alert> watchAlerts();
  Stream<bool> watchLive();
}
