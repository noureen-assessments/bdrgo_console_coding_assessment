import 'package:equatable/equatable.dart';

class TripSeriesPoint extends Equatable {
  const TripSeriesPoint({
    required this.bucket,
    required this.total,
    required this.completed,
    required this.cancelled,
  });

  final DateTime bucket;
  final int total;
  final int completed;
  final int cancelled;

  @override
  List<Object?> get props => [bucket, total, completed, cancelled];
}
