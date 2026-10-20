import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'sse_transport.dart';

SseTransport createSseTransport() => const EventSourceTransport();

final class EventSourceTransport implements SseTransport {
  const EventSourceTransport();

  @override
  Stream<SseTransportEvent> connect(
    Uri url, {
    required List<String> eventNames,
    required bool withCredentials,
  }) {
    web.EventSource? source;
    late final StreamController<SseTransportEvent> controller;

    void onError(web.Event _) {
      if (source?.readyState == web.EventSource.CLOSED) {
        controller
          ..add(const SseTransportRefused())
          ..close();
      } else {
        controller.add(const SseTransportRetrying());
      }
    }

    void open() {
      final eventSource = web.EventSource(
        url.toString(),
        web.EventSourceInit(withCredentials: withCredentials),
      );
      eventSource
        ..onopen = ((web.Event _) => controller.add(
          const SseTransportOpened(),
        )).toJS
        ..onerror = onError.toJS;
      for (final name in eventNames) {
        eventSource.addEventListener(
          name,
          ((web.MessageEvent event) {
            final data = event.data.dartify();
            if (data is String) controller.add(SseTransportMessage(name, data));
          }).toJS,
        );
      }
      source = eventSource;
    }

    controller = StreamController<SseTransportEvent>(
      onListen: open,
      onCancel: () => source?.close(),
    );
    return controller.stream;
  }
}
