import 'package:equatable/equatable.dart';

import 'trip_status.dart';
import 'trip_summary.dart';

class TripFilter extends Equatable {
  const TripFilter({
    this.statuses = const {},
    this.from,
    this.to,
    this.search,
  });

  /// Cancelled trips are many and rarely needed, so with no status picked
  /// they are left out. Picking Cancelled shows them.
  static const defaultStatuses = {
    TripStatus.requested,
    TripStatus.assigned,
    TripStatus.inProgress,
    TripStatus.completed,
  };

  final Set<TripStatus> statuses;

  final DateTime? from;
  final DateTime? to;

  final String? search;

  /// The statuses the list asks for.
  Set<TripStatus> get shownStatuses =>
      statuses.isEmpty ? defaultStatuses : statuses;

  bool get isEmpty =>
      statuses.isEmpty && from == null && to == null && search == null;

  TripFilter withStatuses(Set<TripStatus> statuses) =>
      TripFilter(statuses: statuses, from: from, to: to, search: search);

  TripFilter withDates(DateTime? from, DateTime? to) =>
      TripFilter(statuses: statuses, from: from, to: to, search: search);

  TripFilter withSearch(String? search) =>
      TripFilter(statuses: statuses, from: from, to: to, search: search);

  bool matches(TripSummary trip) {
    if (search != null) return false;
    if (!shownStatuses.contains(trip.status)) return false;

    final firstDay = from;
    if (firstDay != null && trip.requestedAt.isBefore(firstDay)) return false;

    final lastDay = to;
    if (lastDay != null) {
      final dayAfter = DateTime(lastDay.year, lastDay.month, lastDay.day + 1);
      if (!trip.requestedAt.isBefore(dayAfter)) return false;
    }
    return true;
  }

  @override
  List<Object?> get props => [statuses, from, to, search];
}
