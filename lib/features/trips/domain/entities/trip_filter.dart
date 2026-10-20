import 'package:equatable/equatable.dart';

import 'trip_status.dart';

class TripFilter extends Equatable {
  const TripFilter({
    this.statuses = const {},
    this.from,
    this.to,
    this.search,
  });

  final Set<TripStatus> statuses;

  final DateTime? from;
  final DateTime? to;

  final String? search;

  bool get isEmpty =>
      statuses.isEmpty && from == null && to == null && search == null;

  TripFilter withStatuses(Set<TripStatus> statuses) =>
      TripFilter(statuses: statuses, from: from, to: to, search: search);

  TripFilter withDates(DateTime? from, DateTime? to) =>
      TripFilter(statuses: statuses, from: from, to: to, search: search);

  TripFilter withSearch(String? search) =>
      TripFilter(statuses: statuses, from: from, to: to, search: search);

  @override
  List<Object?> get props => [statuses, from, to, search];
}
