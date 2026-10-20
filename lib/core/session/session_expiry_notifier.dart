import 'dart:async';

/// The single place every transport reports a `401`. REST and GraphQL report
/// through Dio, SSE and WebSocket clients call [notify] themselves. The auth
/// feature listens and signs the user out locally, once.
final class SessionExpiryNotifier {
  final _controller = StreamController<void>.broadcast();

  Stream<void> get onExpired => _controller.stream;

  void notify() {
    if (!_controller.isClosed) _controller.add(null);
  }

  Future<void> dispose() => _controller.close();
}
