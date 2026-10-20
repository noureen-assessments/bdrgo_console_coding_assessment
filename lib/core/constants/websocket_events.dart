abstract final class WebSocketEndpoints {
  static const path = '/ws';
}

/// Channels the client subscribes to over the WebSocket.
enum WebSocketChannel {
  /// Live driver positions and status for the map.
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
