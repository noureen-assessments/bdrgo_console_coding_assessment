import 'package:equatable/equatable.dart';

import 'trip_summary.dart';

class TripPage extends Equatable {
  const TripPage({
    required this.trips,
    required this.totalCount,
    required this.endCursor,
    required this.hasNextPage,
  });

  final List<TripSummary> trips;

  final int totalCount;

  final String? endCursor;
  final bool hasNextPage;


  TripPage append(TripPage next) {
    final shownIds = <String>{};
    for (final trip in trips) {
      shownIds.add(trip.id);
    }
    final merged = [...trips];
    for (final trip in next.trips) {
      if (!shownIds.contains(trip.id)) merged.add(trip);
    }
    return TripPage(
      trips: merged,
      totalCount: next.totalCount,
      endCursor: next.endCursor,
      hasNextPage: next.hasNextPage,
    );
  }

  TripSummary? find(String tripId) {
    for (final trip in trips) {
      if (trip.id == tripId) return trip;
    }
    return null;
  }

  bool contains(String tripId) => find(tripId) != null;

  TripPage replace(TripSummary trip) {
    final updated = <TripSummary>[];
    for (final row in trips) {
      updated.add(row.id == trip.id ? trip : row);
    }
    return TripPage(
      trips: updated,
      totalCount: totalCount,
      endCursor: endCursor,
      hasNextPage: hasNextPage,
    );
  }

  TripPage addOnTop(TripSummary trip) => TripPage(
    trips: [trip, ...trips],
    totalCount: totalCount + 1,
    endCursor: endCursor,
    hasNextPage: hasNextPage,
  );

  @override
  List<Object?> get props => [trips, totalCount, endCursor, hasNextPage];
}
