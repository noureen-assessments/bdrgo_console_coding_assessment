import 'dart:async';

import 'package:badrgo_console_assesment/features/auth/domain/entities/permission.dart';
import 'package:badrgo_console_assesment/features/auth/domain/entities/permissions.dart';
import 'package:badrgo_console_assesment/features/auth/domain/services/session_access.dart';
import 'package:badrgo_console_assesment/features/connectivity/domain/repositories/connectivity_repository.dart';

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

final class FakeSessionAccess implements SessionAccess {
  FakeSessionAccess(this.permissions);

  Permissions? permissions;

  @override
  bool get isSignedIn => permissions != null;

  @override
  bool can(Permission permission) {
    final current = permissions;
    if (current == null) return false;
    return current.can(permission);
  }
}
