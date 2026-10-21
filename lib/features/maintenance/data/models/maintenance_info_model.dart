import '../../../../core/errors/failures.dart';
import '../../domain/entities/maintenance_info.dart';
import '../../domain/entities/maintenance_reason.dart';

class MaintenanceInfoModel extends MaintenanceInfo {
  const MaintenanceInfoModel({
    required super.message,
    required super.reason,
    required super.since,
    required super.retryAfter,
  });

  factory MaintenanceInfoModel.fromFailure(MaintenanceFailure failure) {
    return MaintenanceInfoModel(
      message: failure.message,
      reason: MaintenanceReason.fromValue(failure.reason),
      since: failure.since,
      retryAfter: failure.retryAfter,
    );
  }
}
