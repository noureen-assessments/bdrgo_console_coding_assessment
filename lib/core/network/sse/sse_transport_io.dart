import 'sse_transport.dart';

SseTransport createSseTransport() => const UnsupportedSseTransport();

final class UnsupportedSseTransport implements SseTransport {
  const UnsupportedSseTransport();

  @override
  Stream<SseTransportEvent> connect(
    Uri url, {
    required List<String> eventNames,
    required bool withCredentials,
  }) => const Stream.empty();
}
