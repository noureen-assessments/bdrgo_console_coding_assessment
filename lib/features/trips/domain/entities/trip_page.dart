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

  @override
  List<Object?> get props => [trips, totalCount, endCursor, hasNextPage];
}
