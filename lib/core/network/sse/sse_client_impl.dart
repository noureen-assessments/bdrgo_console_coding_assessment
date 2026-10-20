import 'dart:async';
import 'dart:convert';

import '../../constants/log_constants.dart';
import '../../constants/sse_events.dart';
import '../../session/session_checker.dart';
import '../../storage/token_storage.dart';
import '../../utils/logger.dart';
import '../api_urls.dart';
import '../backoff.dart';
import 'sse_client.dart';
import 'sse_transport.dart';

final class SseClientImpl implements SseClient {
  SseClientImpl({
    required SseTransport transport,
    required ApiUrls urls,
    required TokenStorage tokenStorage,
    required SessionChecker sessionChecker,
    Backoff backoff = const Backoff(),
    bool withCredentials = false,
  }) : _transport = transport,
       _urls = urls,
       _tokenStorage = tokenStorage,
       _sessionChecker = sessionChecker,
       _backoff = backoff,
       _withCredentials = withCredentials;

  final SseTransport _transport;
  final ApiUrls _urls;
  final TokenStorage _tokenStorage;
  final SessionChecker _sessionChecker;
  final Backoff _backoff;
  final bool _withCredentials;

  late final _messages = StreamController<SseMessage>.broadcast(
    onListen: _connect,
    onCancel: _disconnect,
  );
  final _statusChanges = StreamController<SseStatus>.broadcast();

  var _status = SseStatus.closed;
  StreamSubscription<SseTransportEvent>? _connection;
  Timer? _retryTimer;
  var _attempt = 0;

  @override
  Stream<SseMessage> get messages => _messages.stream;

  @override
  Stream<SseStatus> get status async* {
    yield _status;
    yield* _statusChanges.stream;
  }

  Future<void> _connect() async {
    _setStatus(SseStatus.connecting);
    final token = await _tokenStorage.getToken();
    if (!_messages.hasListener || _connection != null) return;
    _connection = _transport
        .connect(
          _urls.events(token: token),
          eventNames: SseEvent.values.map((event) => event.name).toList(),
          withCredentials: _withCredentials,
        )
        .listen(_onTransportEvent);
  }

  void _disconnect() {
    _retryTimer?.cancel();
    _retryTimer = null;
    _connection?.cancel();
    _connection = null;
    _attempt = 0;
    _setStatus(SseStatus.closed);
  }

  void _onTransportEvent(SseTransportEvent event) {
    switch (event) {
      case SseTransportOpened():
        _attempt = 0;
        _setStatus(SseStatus.open);
      case final SseTransportMessage message:
        _onMessage(message);
      case SseTransportRetrying():
        _setStatus(SseStatus.connecting);
      case SseTransportRefused():
        _connection = null;
        _setStatus(SseStatus.connecting);
        _retryAfterSessionCheck();
    }
  }

  void _onMessage(SseTransportMessage message) {
    final event = SseEvent.fromName(message.event);
    final data = _decode(message.data);
    if (event == null || data == null) return;
    _messages.add(SseMessage(event, data));
  }

  Future<void> _retryAfterSessionCheck() async {
    AppLogger.warning(LogMessages.sseRefused, name: LogTags.sse);
    await _sessionChecker.check();
    if (!_messages.hasListener || _connection != null) return;
    _retryTimer = Timer(_backoff.delay(_attempt), _connect);
    _attempt++;
  }

  void _setStatus(SseStatus status) {
    if (status == _status) return;
    _status = status;
    _statusChanges.add(status);
  }

  static Map<String, Object?>? _decode(String data) {
    try {
      final json = jsonDecode(data);
      if (json is Map<String, Object?>) return json;
    } on FormatException catch (_) {}
    AppLogger.warning(LogMessages.sseBadFrame, name: LogTags.sse);
    return null;
  }
}
