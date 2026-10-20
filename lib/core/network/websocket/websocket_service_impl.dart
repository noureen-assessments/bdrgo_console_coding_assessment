import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../constants/websocket_events.dart';
import '../../storage/token_storage.dart';
import '../api_urls.dart';
import 'websocket_message.dart';
import 'websocket_service.dart';

typedef WebSocketConnector = WebSocketChannel Function(Uri url);

final class WebSocketServiceImpl implements WebSocketService {
  WebSocketServiceImpl({
    required ApiUrls urls,
    required TokenStorage tokenStorage,
    WebSocketConnector connector = WebSocketChannel.connect,
  }) : _urls = urls,
       _tokenStorage = tokenStorage,
       _connector = connector;

  final ApiUrls _urls;
  final TokenStorage _tokenStorage;
  final WebSocketConnector _connector;

  final _topics = <WebSocketTopic, StreamController<Map<String, Object?>>>{};
  final _statusChanges = StreamController<WebSocketStatus>.broadcast();

  var _status = WebSocketStatus.closed;
  WebSocketChannel? _channel;
  StreamSubscription<Object?>? _connection;

  @override
  Stream<Map<String, Object?>> watch(WebSocketTopic topic) {
    var controller = _topics[topic];
    if (controller == null) {
      controller = StreamController<Map<String, Object?>>.broadcast(
        onListen: _connect,
        onCancel: _disconnectWhenUnused,
      );
      _topics[topic] = controller;
    }
    return controller.stream;
  }

  @override
  Stream<WebSocketStatus> get status async* {
    yield _status;
    yield* _statusChanges.stream;
  }

  bool get _hasListeners {
    for (final controller in _topics.values) {
      if (controller.hasListener) return true;
    }
    return false;
  }

  Future<void> _connect() async {
    if (_channel != null) return;
    _setStatus(WebSocketStatus.connecting);
    final token = await _tokenStorage.getToken();
    if (!_hasListeners || _channel != null) return;
    final channel = _connector(_urls.webSocket(token: token));
    _channel = channel;
    _connection = channel.stream.listen(_onData, onDone: _onClosed);
    channel.ready.then((_) => _onOpened(channel), onError: (Object _) {});
  }

  void _onOpened(WebSocketChannel channel) {
    if (channel != _channel) return;
    _setStatus(WebSocketStatus.open);
  }

  void _onData(Object? data) {
    final message = WebSocketMessage.decode(data);
    if (message == null) return;
    for (final entry in _topics.entries) {
      if (entry.key.messageType == message.type) {
        entry.value.add(message.payload);
      }
    }
  }

  void _onClosed() {
    _closeConnection();
    _setStatus(WebSocketStatus.closed);
  }

  void _disconnectWhenUnused() {
    if (_hasListeners) return;
    _closeConnection();
    _setStatus(WebSocketStatus.closed);
  }

  void _closeConnection() {
    _connection?.cancel();
    _connection = null;
    _channel?.sink.close();
    _channel = null;
  }

  void _setStatus(WebSocketStatus status) {
    if (status == _status) return;
    _status = status;
    _statusChanges.add(status);
  }
}
