import 'dart:async';

import 'package:badrgo_console_assesment/features/connectivity/domain/repositories/connectivity_repository.dart';

/// Connectivity the test drives by hand.
final class FakeConnectivity implements ConnectivityRepository {
  final _controller = StreamController<bool>.broadcast();
  bool online = true;

  void set({required bool online}) {
    this.online = online;
    _controller.add(online);
  }

  @override
  Future<bool> isOnline() async => online;

  @override
  Stream<bool> watchOnline() => _controller.stream;
}
