import '../../../../core/constants/app_strings.dart';
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

  factory MaintenanceInfoModel.fromJson(Map<String, dynamic> json) {
    var message = json['message'] as String?;
    if (message == null || message.isEmpty) {
      message = AppStrings.maintenanceMessage;
    }
    final since = json['since'] as String?;
    return MaintenanceInfoModel(
      message: message,
      reason: MaintenanceReason.fromValue(json['reason'] as String?),
      since: since == null ? null : DateTime.tryParse(since),
      retryAfter: null,
    );
  }

  factory MaintenanceInfoModel.fromFailure(MaintenanceFailure failure) {
    return MaintenanceInfoModel(
      message: failure.message,
      reason: MaintenanceReason.fromValue(failure.reason),
      since: failure.since,
      retryAfter: failure.retryAfter,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'reason': reason.value,
    'since': since?.toIso8601String(),
  };
}
