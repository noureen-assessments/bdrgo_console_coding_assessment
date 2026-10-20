abstract final class WebSocketEndpoints {
  static const path = '/ws';
}

enum WebSocketChannel {
  driversLocations('drivers.locations');

  const WebSocketChannel(this.name);

  final String name;

  static WebSocketChannel? fromName(String name) {
    for (final channel in values) {
      if (channel.name == name) return channel;
    }
    return null;
  }
}
