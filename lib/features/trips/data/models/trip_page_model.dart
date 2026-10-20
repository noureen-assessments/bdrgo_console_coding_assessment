import '../../domain/entities/trip_page.dart';
import 'trip_summary_model.dart';


/// A GraphQL `TripConnection`.
class TripPageModel extends TripPage {
  const TripPageModel({
    required List<TripSummaryModel> super.trips,
    required super.totalCount,
    required super.endCursor,
    required super.hasNextPage,
  });

  factory TripPageModel.fromJson(Map<String, dynamic> json) {
    final pageInfo = json['pageInfo'] as Map<String, dynamic>;
    return TripPageModel(
      trips: TripSummaryModel.listFromJson(json['nodes'] as List<dynamic>),
      totalCount: (json['totalCount'] as num).toInt(),
      endCursor: pageInfo['endCursor'] as String?,
      hasNextPage: pageInfo['hasNextPage'] as bool,
    );
  }

  @override
  List<TripSummaryModel> get trips => super.trips as List<TripSummaryModel>;

  Map<String, dynamic> toJson() => {
    'nodes': trips.map((trip) => trip.toJson()).toList(),
    'totalCount': totalCount,
    'pageInfo': {'endCursor': endCursor, 'hasNextPage': hasNextPage},
  };
}
