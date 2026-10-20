import '../../domain/entities/trip_status.dart';
import '../../domain/entities/trip_timeline_entry.dart';

class TripTimelineEntryModel extends TripTimelineEntry {
  const TripTimelineEntryModel({required super.status, required super.at});

  factory TripTimelineEntryModel.fromJson(Map<String, dynamic> json) =>
      TripTimelineEntryModel(
        status: TripStatus.fromValue(json['status'] as String),
        at: DateTime.parse(json['at'] as String),
      );

  static List<TripTimelineEntryModel> listFromJson(List<dynamic> json) {
    final entries = <TripTimelineEntryModel>[];
    for (final item in json) {
      entries.add(TripTimelineEntryModel.fromJson(item as Map<String, dynamic>));
    }
    return entries;
  }

  Map<String, dynamic> toJson() => {
    'status': status.value,
    'at': at.toIso8601String(),
  };
}
