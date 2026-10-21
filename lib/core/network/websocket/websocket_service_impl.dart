import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../constants/log_constants.dart';
import '../../constants/websocket_events.dart';
import '../../session/session_checker.dart';
import '../../storage/token_storage.dart';
import '../../utils/logger.dart';
import '../api_urls.dart';
import '../backoff.dart';
import 'websocket_message.dart';
import 'websocket_service.dart';

typedef WebSocketConnector = WebSocketChannel Function(Uri url);

final class WebSocketServiceImpl implements WebSocketService {
  WebSocketServiceImpl({
    required ApiUrls urls,
    required TokenStorage tokenStorage,
    required SessionChecker sessionChecker,
    Backoff backoff = const Backoff(),
    WebSocketConnector connector = WebSocketChannel.connect,
  }) : _urls = urls,
       _tokenStorage = tokenStorage,
       _sessionChecker = sessionChecker,
       _backoff = backoff,
       _connector = connector;

  final ApiUrls _urls;
  final TokenStorage _tokenStorage;
  final SessionChecker _sessionChecker;
  final Backoff _backoff;
  final WebSocketConnector _connector;

  final _topics = <WebSocketTopic, StreamController<Map<String, Object?>>>{};
  final _statusChanges = StreamController<WebSocketStatus>.broadcast();

  var _status = WebSocketStatus.closed;
  WebSocketChannel? _channel;
  StreamSubscription<Object?>? _connection;
  Timer? _retryTimer;
  var _attempt = 0;

  @override
  Stream<Map<String, Object?>> watch(WebSocketTopic topic) {
    var controller = _topics[topic];
    if (controller == null) {
      controller = StreamController<Map<String, Object?>>.broadcast(
        onListen: () => _onListen(topic),
        onCancel: () => _onCancel(topic),
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

  void _onListen(WebSocketTopic topic) {
    if (_status == WebSocketStatus.open) {
      _send(WebSocketMessage.subscribe(topic));
      return;
    }
    _connect();
  }

  void _onCancel(WebSocketTopic topic) {
    if (!_hasListeners) {
      _disconnect();
      return;
    }
    if (_status == WebSocketStatus.open) {
      _send(WebSocketMessage.unsubscribe(topic));
    }
  }

  Future<void> _connect() async {
    if (_channel != null) return;
    _setStatus(WebSocketStatus.connecting);
    final token = await _tokenStorage.getToken();
    if (!_hasListeners || _channel != null) return;
    final channel = _connector(_urls.webSocket(token: token));
    _channel = channel;
    _connection = channel.stream.listen(_onData, onError: (Object _) {}, onDone: _onClosed,);
    unawaited(channel.ready.then((_) => _onOpened(channel), onError: (Object _) {}));
  }

  void _onOpened(WebSocketChannel channel) {
    if (channel != _channel) return;
    _attempt = 0;
    _setStatus(WebSocketStatus.open);
    _subscribeAll();
  }

  void _subscribeAll() {
    for (final entry in _topics.entries) {
      if (entry.value.hasListener) {
        _send(WebSocketMessage.subscribe(entry.key));
      }
    }
  }

  void _send(WebSocketMessage message) {
    final channel = _channel;
    if (channel == null) return;
    channel.sink.add(message.encode());
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
    final channel = _channel;
    int? closeCode;
    if (channel != null) closeCode = channel.closeCode;
    _closeConnection();

    if (closeCode == WebSocketCloseCodes.unauthorized) {
      AppLogger.warning(
        LogMessages.webSocketUnauthorized,
        name: LogTags.webSocket,
      );
      _setStatus(WebSocketStatus.closed);
      _sessionChecker.check();
      return;
    }

    _setStatus(WebSocketStatus.connecting);
    _retryAfterSessionCheck();
  }

  Future<void> _retryAfterSessionCheck() async {
    AppLogger.warning(LogMessages.webSocketDropped, name: LogTags.webSocket);
    await _sessionChecker.check();
    if (!_hasListeners || _channel != null) return;
    _retryTimer = Timer(_backoff.delay(_attempt), _connect);
    _attempt++;
  }

  void _disconnect() {
    _retryTimer?.cancel();
    _retryTimer = null;
    _attempt = 0;
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
