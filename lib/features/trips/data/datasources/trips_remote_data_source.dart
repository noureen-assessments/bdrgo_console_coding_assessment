import '../../../../core/constants/log_constants.dart';
import '../../../../core/constants/sse_events.dart';
import '../../../../core/network/graphql_consumer.dart';
import '../../../../core/network/sse/sse_client.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/trip_page_request.dart';
import '../models/trip_change_model.dart';
import '../models/trip_page_model.dart';
import '../models/trip_summary_model.dart';
import '../queries/trips_queries.dart';


abstract interface class TripsRemoteDataSource {
  Future<TripPageModel> fetchTrips(TripPageRequest request);

  Future<TripSummaryModel?> fetchTrip(String id);
  Stream<TripChangeModel> watchTripChanges();
}

final class TripsRemoteDataSourceImpl implements TripsRemoteDataSource {
  const TripsRemoteDataSourceImpl(this._graphql, this._sse);

  final GraphQLConsumer _graphql;
  final SseClient _sse;

  @override
  Future<TripPageModel> fetchTrips(TripPageRequest request) async {
    final data = await _graphql.query(
      TripsQueries.trips,
      variables: TripsQueries.tripsVariables(request),
    );
    try {
      return TripPageModel.fromJson(data['trips'] as Map<String, dynamic>);
    } on TypeError {
      throw const FormatException('trips');
    }
  }

  @override
  Future<TripSummaryModel?> fetchTrip(String id) async {
    final data = await _graphql.query(
      TripsQueries.trip,
      variables: TripsQueries.tripVariables(id),
    );
    final trip = data['trip'];
    if (trip == null) return null;
    try {
      return TripSummaryModel.fromJson(trip as Map<String, dynamic>);
    } on TypeError {
      throw const FormatException('trip');
    }
  }

  @override
  Stream<TripChangeModel> watchTripChanges() => _sse.messages
      .where(
        (message) =>
            message.event == SseEvent.tripCreated ||
            message.event == SseEvent.tripUpdated,
      )
      .expand(_parseChange);

  static List<TripChangeModel> _parseChange(SseMessage message) {
    try {
      return [TripChangeModel.fromSse(message)];
    } on TypeError {
      AppLogger.warning(LogMessages.sseBadFrame, name: LogTags.sse);
    }
    return const [];
  }
}
