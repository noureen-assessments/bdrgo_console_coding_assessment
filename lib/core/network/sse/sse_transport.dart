
abstract interface class SseTransport {

  Stream<SseTransportEvent> connect(
    Uri url, {
    required List<String> eventNames,
    required bool withCredentials,
  });
}

sealed class SseTransportEvent {
  const SseTransportEvent();
}

final class SseTransportOpened extends SseTransportEvent {
  const SseTransportOpened();
}

final class SseTransportMessage extends SseTransportEvent {
  const SseTransportMessage(this.event, this.data);

  final String event;
  final String data;
}

/// The connection dropped and the browser is reconnecting by itself.
final class SseTransportRetrying extends SseTransportEvent {
  const SseTransportRetrying();
}

/// refused the connection (any non-`200` such as `401`, `403` or
/// `503`),
final class SseTransportRefused extends SseTransportEvent {
  const SseTransportRefused();
}
