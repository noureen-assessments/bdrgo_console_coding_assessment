import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/log_constants.dart';
import '../../../../core/constants/sse_events.dart';
import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/sse/sse_client.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/alert_page_request.dart';
import '../models/alert_model.dart';
import '../models/alert_page_model.dart';

abstract interface class AlertsRemoteDataSource {
  Future<AlertPageModel> fetchAlerts(AlertPageRequest request);
  Stream<AlertModel> watchAlerts();
  Stream<bool> watchLive();
}

final class AlertsRemoteDataSourceImpl implements AlertsRemoteDataSource {
  const AlertsRemoteDataSourceImpl(this._api, this._sse);

  final ApiConsumer _api;
  final SseClient _sse;

  @override
  Future<AlertPageModel> fetchAlerts(AlertPageRequest request) async {
    final body = await _api.get(
      ApiEndpoints.alerts,
      queryParameters: _queryParameters(request),
    );
    try {
      return AlertPageModel.fromJson(body as Map<String, dynamic>);
    } on TypeError {
      throw const FormatException(ApiEndpoints.alerts);
    }
  }

  @override
  Stream<AlertModel> watchAlerts() => _sse.messages
      .where(
        (message) =>
            message.event == SseEvent.alertCreated ||
            message.event == SseEvent.alertAcknowledged,
      )
      .expand(_parseAlert);

  @override
  Stream<bool> watchLive() =>
      _sse.status.map((status) => status == SseStatus.open).distinct();

  static Map<String, Object?> _queryParameters(AlertPageRequest request) => {
    'page': request.page,
    'pageSize': request.pageSize,
  };

  static List<AlertModel> _parseAlert(SseMessage message) {
    try {
      return [AlertModel.fromJson(message.data['alert'] as Map<String, dynamic>)];
    } on TypeError {
      AppLogger.warning(LogMessages.sseBadFrame, name: LogTags.sse);
    } on FormatException {
      AppLogger.warning(LogMessages.sseBadFrame, name: LogTags.sse);
    }
    return const [];
  }
}
