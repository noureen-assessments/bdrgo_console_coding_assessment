import '../../constants/sse_events.dart';

/// The app's one Server-Sent Events connection. Features listen to
/// [messages] and keep only the events they need (dashboard: `kpi`, trips:
/// `trip.*`, alerts: `alert.*`).
///
/// The connection opens when [messages] gets its first listener and closes
/// when the last one cancels. Page Blocs cancel when the page closes, and
/// sign-out clears the page stack, so a signed-out user never keeps a
/// connection and an account switch never shares one.
abstract interface class SseClient {
  Stream<SseMessage> get messages;

  /// The current status first, then every change. Listening here does not
  /// open the connection.
  Stream<SseStatus> get status;
}

enum SseStatus {
  /// Nobody listens.
  closed,

  /// Connecting or reconnecting: no events right now.
  connecting,

  /// Events are flowing.
  open,
}

/// One event from the stream, with its `data:` JSON already decoded.
final class SseMessage {
  const SseMessage(this.event, this.data);

  final SseEvent event;
  final Map<String, Object?> data;
}
