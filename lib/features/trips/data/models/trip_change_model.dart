import '../../../../core/network/sse/sse_client.dart';
import '../../domain/entities/trip_change.dart';
import '../../domain/entities/trip_status.dart';


class TripChangeModel extends TripChange {
  const TripChangeModel({required super.tripId, required super.status});

  factory TripChangeModel.fromSse(SseMessage message) {
    final trip = message.data['trip'] as Map<String, dynamic>;
    return TripChangeModel(
      tripId: trip['id'] as String,
      status: TripStatus.fromValue(trip['status'] as String),
    );
  }
}
