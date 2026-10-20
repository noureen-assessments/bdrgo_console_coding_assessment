import 'dart:async';

/// The single place every transport reports a `403`. A `403` usually means
/// the user's role changed on the server, so the auth feature listens and
/// re-fetches `/api/me`; the console then adapts to the new permissions.
///
/// REST and GraphQL report through Dio, SSE and WebSocket clients call
/// [notify] themselves.
final class AccessDeniedNotifier {
  final _controller = StreamController<void>.broadcast();

  Stream<void> get onDenied => _controller.stream;

  void notify() {
    if (!_controller.isClosed) _controller.add(null);
  }

  Future<void> dispose() => _controller.close();
}
