import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_consumer.dart';
import '../../../../core/session/maintenance_notifier.dart';
import '../models/maintenance_info_model.dart';

abstract interface class MaintenanceRemoteDataSource {
  Stream<MaintenanceInfoModel> watchMaintenance();
  Future<MaintenanceInfoModel?> checkHealth();
}

final class MaintenanceRemoteDataSourceImpl
    implements MaintenanceRemoteDataSource {
  const MaintenanceRemoteDataSourceImpl(this._api, this._notifier);

  final ApiConsumer _api;
  final MaintenanceNotifier _notifier;

  @override
  Stream<MaintenanceInfoModel> watchMaintenance() =>
      _notifier.onMaintenance.map(MaintenanceInfoModel.fromFailure);

  @override
  Future<MaintenanceInfoModel?> checkHealth() async {
    try {
      await _api.get(ApiEndpoints.health);
      return null;
    } on MaintenanceFailure catch (failure) {
      return MaintenanceInfoModel.fromFailure(failure);
    }
  }
}
