import 'package:equatable/equatable.dart';

import 'trip_filter.dart';

class TripPageRequest extends Equatable {
  const TripPageRequest({required this.filter, this.after});

  final TripFilter filter;
  final String? after;

  @override
  List<Object?> get props => [filter, after];
}
