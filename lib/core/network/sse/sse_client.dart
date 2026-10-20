import '../../constants/sse_events.dart';

abstract interface class SseClient {
  Stream<SseMessage> get messages;

  Stream<SseStatus> get status;
}

enum SseStatus {
  closed,

  connecting,

  open,
}

final class SseMessage {
  const SseMessage(this.event, this.data);

  final SseEvent event;
  final Map<String, Object?> data;
}
