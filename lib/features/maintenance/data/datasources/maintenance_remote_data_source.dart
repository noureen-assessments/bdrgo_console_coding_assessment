import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/sse/sse_client.dart';
import '../../../../core/network/websocket/websocket_service.dart';
import '../../../../core/session/maintenance_notifier.dart';
import '../models/maintenance_info_model.dart';

abstract interface class MaintenanceRemoteDataSource {
  Stream<MaintenanceInfoModel> watchMaintenance();
  Future<MaintenanceInfoModel?> checkHealth();
  void reconnectRealtime();
}

final class MaintenanceRemoteDataSourceImpl
    implements MaintenanceRemoteDataSource {
  const MaintenanceRemoteDataSourceImpl(
    this._api,
    this._notifier,
    this._sse,
    this._webSocket,
  );

  final ApiConsumer _api;
  final MaintenanceNotifier _notifier;
  final SseClient _sse;
  final WebSocketService _webSocket;

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

  @override
  void reconnectRealtime() {
    _sse.reconnectNow();
    _webSocket.reconnectNow();
  }
}
