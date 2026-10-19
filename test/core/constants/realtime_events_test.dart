import 'package:badrgo_console_assesment/core/constants/sse_events.dart';
import 'package:badrgo_console_assesment/core/constants/websocket_events.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SseEvent maps the server event names', () {
    expect(SseEvent.fromName('kpi'), SseEvent.kpi);
    expect(SseEvent.fromName('trip.created'), SseEvent.tripCreated);
    expect(SseEvent.fromName('trip.updated'), SseEvent.tripUpdated);
    expect(SseEvent.fromName('alert.created'), SseEvent.alertCreated);
    expect(SseEvent.fromName('alert.acknowledged'), SseEvent.alertAcknowledged);
  });

  test('unknown event and channel names are ignored, not thrown', () {
    expect(SseEvent.fromName('driver.rated'), isNull);
    expect(WebSocketChannel.fromName('unknown.channel'), isNull);
  });

  test('WebSocketChannel maps drivers.locations', () {
    expect(
      WebSocketChannel.fromName('drivers.locations'),
      WebSocketChannel.driversLocations,
    );
  });
}
