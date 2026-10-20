import 'dart:async';


final class AccessDeniedNotifier {
  final _controller = StreamController<void>.broadcast();

  Stream<void> get onDenied => _controller.stream;

  void notify() {
    if (!_controller.isClosed) _controller.add(null);
  }

  Future<void> dispose() => _controller.close();
}
