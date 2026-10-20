import '../../domain/entities/trip_series_point.dart';

class TripSeriesPointModel extends TripSeriesPoint {
  const TripSeriesPointModel({
    required super.bucket,
    required super.total,
    required super.completed,
    required super.cancelled,
  });

  factory TripSeriesPointModel.fromJson(Map<String, dynamic> json) =>
      TripSeriesPointModel(
        bucket: DateTime.parse(json['bucket'] as String),
        total: (json['total'] as num).toInt(),
        completed: (json['completed'] as num).toInt(),
        cancelled: (json['cancelled'] as num).toInt(),
      );

  static List<TripSeriesPointModel> listFromJson(List<dynamic> json) {
    final points = <TripSeriesPointModel>[];
    for (final item in json) {
      points.add(TripSeriesPointModel.fromJson(item as Map<String, dynamic>));
    }
    return points;
  }

  Map<String, dynamic> toJson() => {
    'bucket': bucket.toIso8601String(),
    'total': total,
    'completed': completed,
    'cancelled': cancelled,
  };
}
