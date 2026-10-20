import '../../../../core/constants/sse_events.dart';
import '../../../../core/network/sse/sse_client.dart';
import '../../domain/entities/trip_change.dart';


class TripChangeModel extends TripChange {
  const TripChangeModel({required super.tripId, required super.isNew});

  factory TripChangeModel.fromSse(SseMessage message) {
    final trip = message.data['trip'] as Map<String, dynamic>;
    return TripChangeModel(
      tripId: trip['id'] as String,
      isNew: message.event == SseEvent.tripCreated,
    );
  }
}
