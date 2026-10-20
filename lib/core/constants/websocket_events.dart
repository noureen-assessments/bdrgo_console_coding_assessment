abstract final class WebSocketEndpoints {
  static const path = '/ws';
}

abstract final class WebSocketMessageKeys {
  static const type = 'type';
  static const id = 'id';
  static const payload = 'payload';
  static const channel = 'channel';
}

abstract final class WebSocketCloseCodes {
  static const unauthorized = 4001;
}

enum WebSocketMessageType {
  welcome('welcome'),
  ack('ack'),
  error('error'),
  subscribe('subscribe'),
  unsubscribe('unsubscribe'),
  driversLocations('drivers.locations');

  const WebSocketMessageType(this.name);

  final String name;

  static WebSocketMessageType? fromName(String name) {
    for (final type in values) {
      if (type.name == name) return type;
    }
    return null;
  }
}

enum WebSocketTopic {
  driversLocations('drivers.locations');

  const WebSocketTopic(this.name);

  final String name;

  static WebSocketTopic? fromName(String name) {
    for (final topic in values) {
      if (topic.name == name) return topic;
    }
    return null;
  }
}
