import 'dart:async';

import '../errors/failures.dart';

final class MaintenanceNotifier {
  final _controller = StreamController<MaintenanceFailure>.broadcast();

  Stream<MaintenanceFailure> get onMaintenance => _controller.stream;

  void notify(MaintenanceFailure failure) {
    if (!_controller.isClosed) _controller.add(failure);
  }

  Future<void> dispose() => _controller.close();
}
