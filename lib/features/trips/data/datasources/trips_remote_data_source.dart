import '../../../../core/network/graphql_consumer.dart';
import '../../domain/entities/trip_page_request.dart';
import '../models/trip_page_model.dart';
import '../queries/trips_queries.dart';


abstract interface class TripsRemoteDataSource {
  Future<TripPageModel> fetchTrips(TripPageRequest request);
}

final class TripsRemoteDataSourceImpl implements TripsRemoteDataSource {
  const TripsRemoteDataSourceImpl(this._graphql);

  final GraphQLConsumer _graphql;

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
}
