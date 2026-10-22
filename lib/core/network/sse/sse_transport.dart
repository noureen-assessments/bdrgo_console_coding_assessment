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

final class SseTransportRetrying extends SseTransportEvent {
  const SseTransportRetrying();
}

final class SseTransportRefused extends SseTransportEvent {
  const SseTransportRefused();
}
