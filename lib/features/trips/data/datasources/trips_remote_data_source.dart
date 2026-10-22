import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/log_constants.dart';
import '../../../../core/constants/sse_events.dart';
import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/graphql_consumer.dart';
import '../../../../core/network/sse/sse_client.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/trip_action.dart';
import '../../domain/entities/trip_page_request.dart';
import '../models/available_driver_model.dart';
import '../models/trip_change_model.dart';
import '../models/trip_detail_model.dart';
import '../models/trip_page_model.dart';
import '../models/trip_summary_model.dart';
import '../queries/trips_queries.dart';


abstract interface class TripsRemoteDataSource {
  Future<TripPageModel> fetchTrips(TripPageRequest request);
  Future<TripSummaryModel?> fetchTrip(String id);
  Future<TripDetailModel?> fetchTripDetail(String id);
  Stream<TripChangeModel> watchTripChanges();
  Future<void> perform(TripAction action);
  Future<List<AvailableDriverModel>> fetchAvailableDrivers(String cityId);
}

final class TripsRemoteDataSourceImpl implements TripsRemoteDataSource {
  const TripsRemoteDataSourceImpl(this._graphql, this._sse, this._api);

  final GraphQLConsumer _graphql;
  final SseClient _sse;
  final ApiConsumer _api;

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
    } on FormatException {
      AppLogger.warning(LogMessages.sseBadFrame, name: LogTags.sse);
    }
    return const [];
  }

  @override
  Future<void> perform(TripAction action) async {
    final String path;
    final Map<String, Object?> body;
    switch (action) {
      case AssignDriver():
        path = ApiEndpoints.assignTrip(action.tripId);
        body = {'driverId': action.driverId};
      case CancelTrip():
        path = ApiEndpoints.cancelTrip(action.tripId);
        body = {'reason': action.reason};
      case RefundTrip():
        path = ApiEndpoints.refundTrip(action.tripId);
        body = {'amount': action.amount, 'reason': action.reason};
    }
    await _api.post(path, data: body);
  }

  @override
  Future<List<AvailableDriverModel>> fetchAvailableDrivers(
    String cityId,
  ) async {
    final data = await _graphql.query(
      TripsQueries.availableDrivers,
      variables: TripsQueries.availableDriversVariables(cityId),
    );
    try {
      final drivers = data['drivers'] as Map<String, dynamic>;
      return AvailableDriverModel.listFromJson(drivers['nodes'] as List<dynamic>);
    } on TypeError {
      throw const FormatException('drivers');
    }
  }

  @override
  Future<TripDetailModel?> fetchTripDetail(String id) async {
    final data = await _graphql.query(
      TripsQueries.tripDetail,
      variables: TripsQueries.tripVariables(id),
    );
    final trip = data['trip'];
    if (trip == null) return null;
    try {
      return TripDetailModel.fromJson(trip as Map<String, dynamic>);
    } on TypeError {
      throw const FormatException('trip detail');
    }
  }
}
