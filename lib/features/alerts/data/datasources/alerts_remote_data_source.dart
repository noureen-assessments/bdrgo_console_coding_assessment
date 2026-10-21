import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_consumer.dart';
import '../../domain/entities/alert_page_request.dart';
import '../models/alert_page_model.dart';

abstract interface class AlertsRemoteDataSource {
  Future<AlertPageModel> fetchAlerts(AlertPageRequest request);
}

final class AlertsRemoteDataSourceImpl implements AlertsRemoteDataSource {
  const AlertsRemoteDataSourceImpl(this._api);

  static const pageSize = 20;

  final ApiConsumer _api;

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

  static Map<String, Object?> _queryParameters(AlertPageRequest request) {
    final parameters = <String, Object?>{
      'page': request.page,
      'pageSize': pageSize,
    };
    final acknowledged = request.acknowledged;
    if (acknowledged != null) {
      parameters['acknowledged'] = acknowledged.toString();
    }
    return parameters;
  }
}
