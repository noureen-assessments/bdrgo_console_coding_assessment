import '../../domain/entities/trip_page_request.dart';


abstract final class TripsQueries {
  static const pageSize = 20;


  static const trips = r'''
    query Trips($first: Int, $after: String) {
      trips(first: $first, after: $after) {
        totalCount
        pageInfo {
          endCursor
          hasNextPage
        }
        nodes {
          id
          status
          requestedAt
          fare {
            amount
            currency
          }
          city {
            name
          }
          rider {
            name
          }
          driver {
            name
          }
          pickup {
            address
          }
          dropoff {
            address
          }
        }
      }
    }
  ''';

  static Map<String, Object?> tripsVariables(TripPageRequest request) => {
    'first': pageSize,
    'after': ?request.after,
  };
}
