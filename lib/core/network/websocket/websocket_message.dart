import 'dart:convert';

import '../../constants/websocket_events.dart';

final class WebSocketMessage {
  const WebSocketMessage(this.type, {this.payload = const {}});

  WebSocketMessage.subscribe(WebSocketTopic topic)
    : this(
        WebSocketMessageType.subscribe,
        payload: {WebSocketMessageKeys.channel: topic.name},
      );

  WebSocketMessage.unsubscribe(WebSocketTopic topic)
    : this(
        WebSocketMessageType.unsubscribe,
        payload: {WebSocketMessageKeys.channel: topic.name},
      );

  final WebSocketMessageType type;
  final Map<String, Object?> payload;

  String encode() {
    return jsonEncode({
      WebSocketMessageKeys.type: type.name,
      WebSocketMessageKeys.payload: payload,
    });
  }

  static WebSocketMessage? decode(Object? data) {
    if (data is! String) return null;

    Object? json;
    try {
      json = jsonDecode(data);
    } on FormatException catch (_) {
      return null;
    }
    if (json is! Map<String, Object?>) return null;

    final typeName = json[WebSocketMessageKeys.type];
    if (typeName is! String) return null;
    final type = WebSocketMessageType.fromName(typeName);
    if (type == null) return null;

    final payload = json[WebSocketMessageKeys.payload];
    if (payload is Map<String, Object?>) {
      return WebSocketMessage(type, payload: payload);
    }
    return WebSocketMessage(type);
  }
}
