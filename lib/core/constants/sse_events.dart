/// Server-Sent Events stream. Browsers cannot set headers on `EventSource`,
/// so the token goes in `?token=`.
abstract final class SseEndpoints {
  static const path = '/api/events';
}

/// Event names on the SSE stream (the `event:` field).
enum SseEvent {
  kpi('kpi'),
  tripCreated('trip.created'),
  tripUpdated('trip.updated'),
  alertCreated('alert.created'),
  alertAcknowledged('alert.acknowledged');

  const SseEvent(this.name);

  final String name;

  /// Null for events the app does not handle, so new server events are
  /// ignored rather than crashing the stream.
  static SseEvent? fromName(String name) {
    for (final event in values) {
      if (event.name == name) return event;
    }
    return null;
  }
}
