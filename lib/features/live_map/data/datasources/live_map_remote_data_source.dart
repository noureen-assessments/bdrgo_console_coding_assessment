import '../../../../core/constants/log_constants.dart';
import '../../../../core/constants/websocket_events.dart';
import '../../../../core/network/graphql_consumer.dart';
import '../../../../core/network/websocket/websocket_service.dart';
import '../../../../core/utils/logger.dart';
import '../models/driver_detail_model.dart';
import '../models/driver_location_model.dart';
import '../queries/live_map_queries.dart';

abstract interface class LiveMapRemoteDataSource {
  Stream<List<DriverLocationModel>> watchDriverLocations();
  Stream<bool> watchLive();
  Future<DriverDetailModel?> fetchDriverDetail(String id);
}

final class LiveMapRemoteDataSourceImpl implements LiveMapRemoteDataSource {
  const LiveMapRemoteDataSourceImpl(this._graphql, this._webSocket);

  final GraphQLConsumer _graphql;
  final WebSocketService _webSocket;

  @override
  Stream<List<DriverLocationModel>> watchDriverLocations() => _webSocket
      .watch(WebSocketTopic.driversLocations)
      .expand(_parseSnapshot);

  static List<List<DriverLocationModel>> _parseSnapshot(
    Map<String, Object?> payload,
  ) {
    try {
      final drivers = payload['drivers'] as List<dynamic>;
      return [DriverLocationModel.listFromJson(drivers)];
    } on TypeError {
      _logBadMessage();
    } on FormatException {
      _logBadMessage();
    }
    return const [];
  }

  static void _logBadMessage() {
    AppLogger.warning(LogMessages.webSocketBadMessage, name: LogTags.webSocket);
  }

  @override
  Stream<bool> watchLive() => _webSocket.status
      .map((status) => status == WebSocketStatus.open)
      .distinct();

  @override
  Future<DriverDetailModel?> fetchDriverDetail(String id) async {
    final data = await _graphql.query(
      LiveMapQueries.driverDetail,
      variables: LiveMapQueries.driverDetailVariables(id),
    );
    final driver = data['driver'];
    if (driver == null) return null;
    try {
      return DriverDetailModel.fromJson(driver as Map<String, dynamic>);
    } on TypeError {
      throw const FormatException('driver detail');
    }
  }
}
