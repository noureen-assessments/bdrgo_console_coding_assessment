abstract final class SseEndpoints {
  static const path = '/api/events';
}

enum SseEvent {
  kpi('kpi'),
  tripCreated('trip.created'),
  tripUpdated('trip.updated'),
  alertCreated('alert.created'),
  alertAcknowledged('alert.acknowledged');

  const SseEvent(this.name);

  final String name;

  static SseEvent? fromName(String name) {
    for (final event in values) {
      if (event.name == name) return event;
    }
    return null;
  }
}
