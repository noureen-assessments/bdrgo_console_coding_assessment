import '../../constants/websocket_events.dart';

abstract interface class WebSocketService {
  Stream<Map<String, Object?>> watch(WebSocketTopic topic);

  Stream<WebSocketStatus> get status;
}

enum WebSocketStatus {
  closed,

  connecting,

  open,
}
