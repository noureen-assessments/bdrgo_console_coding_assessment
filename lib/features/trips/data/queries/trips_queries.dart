import '../../domain/entities/trip_filter.dart';
import '../../domain/entities/trip_page_request.dart';


abstract final class TripsQueries {
  static const pageSize = 20;


static const _tripRow = r'''
    fragment TripRow on Trip {
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
  ''';

  static const trips =
      r'''
    query Trips($filter: TripFilter, $first: Int, $after: String) {
      trips(filter: $filter, first: $first, after: $after) {
        totalCount
        pageInfo {
          endCursor
          hasNextPage
        }
        nodes {
          ...TripRow
        }
      }
    }
  ''' +
      _tripRow;

  /// One trip, for a live update. Null when it is not in the user's city.
  /// Variables: `$id`.
  static const trip =
      r'''
    query Trip($id: ID!) {
      trip(id: $id) {
        ...TripRow
      }
    }
  ''' +
      _tripRow;

  static Map<String, Object?> tripVariables(String id) => {'id': id};

  static Map<String, Object?> tripsVariables(TripPageRequest request) => {
    'first': pageSize,
    'filter': filterVariables(request.filter),
    'after': ?request.after,
  };

  static Map<String, Object?> filterVariables(TripFilter filter) {
    final variables = <String, Object?>{};

    if (filter.statuses.isNotEmpty) {
      final statuses = <String>[];
      for (final status in filter.statuses) {
        statuses.add(status.value);
      }
      variables['status'] = statuses;
    }

    final from = filter.from;
    if (from != null) {
      variables['from'] = from.toUtc().toIso8601String();
    }

    final to = filter.to;
    if (to != null) {
      // The API excludes `to`, so "up to Oct 20" is sent as "before Oct 21".
      final dayAfter = DateTime(to.year, to.month, to.day + 1);
      variables['to'] = dayAfter.toUtc().toIso8601String();
    }

    final search = filter.search;
    if (search != null) {
      variables['search'] = search;
    }

    return variables;
  }
}
