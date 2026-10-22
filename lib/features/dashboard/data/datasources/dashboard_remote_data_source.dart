import '../../../../core/constants/log_constants.dart';
import '../../../../core/constants/sse_events.dart';
import '../../../../core/network/graphql_consumer.dart';
import '../../../../core/network/sse/sse_client.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/kpi_range.dart';
import '../models/kpis_model.dart';
import '../models/trip_series_point_model.dart';
import '../queries/dashboard_queries.dart';


abstract interface class DashboardRemoteDataSource {
  Future<KpisModel> fetchKpis(KpiRange range);
  Future<List<TripSeriesPointModel>> fetchTripSeries(KpiRange range);
  Stream<KpisModel> watchKpis();
  Stream<bool> watchLive();
}

final class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  const DashboardRemoteDataSourceImpl(this._graphql, this._sse);

  final GraphQLConsumer _graphql;
  final SseClient _sse;


  @override
  Future<KpisModel> fetchKpis(KpiRange range) async {
    final data = await _graphql.query(
      DashboardQueries.kpis,
      variables: DashboardQueries.rangeVariables(range),
    );
    try {
      return KpisModel.fromJson(data['kpis'] as Map<String, dynamic>);
    } on TypeError {
      throw const FormatException('kpis');
    }
  }

  @override
  Future<List<TripSeriesPointModel>> fetchTripSeries(KpiRange range) async {
    final data = await _graphql.query(
      DashboardQueries.tripSeries,
      variables: DashboardQueries.rangeVariables(range),
    );
    try {

      final kpis = data['kpis'] as Map<String, dynamic>;
      return TripSeriesPointModel.listFromJson(kpis['series'] as List<dynamic>);
    } on TypeError {
      throw const FormatException('series');
    }
  }

  @override
  Stream<KpisModel> watchKpis() => _sse.messages
      .where((message) => message.event == SseEvent.kpi)
      .expand(_parseLiveKpis);

  @override
  Stream<bool> watchLive() =>
      _sse.status.map((status) => status == SseStatus.open).distinct();


  static List<KpisModel> _parseLiveKpis(SseMessage message) {
    try {
      return [KpisModel.fromJson(message.data)];
    } on TypeError {
      AppLogger.warning(LogMessages.sseBadFrame, name: LogTags.sse);
    } on FormatException {
      AppLogger.warning(LogMessages.sseBadFrame, name: LogTags.sse);
    }
    return const [];
  }
}
