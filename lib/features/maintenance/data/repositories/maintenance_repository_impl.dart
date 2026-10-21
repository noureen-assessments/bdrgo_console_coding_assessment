import '../../../../core/errors/failures.dart';
import '../../../../core/network/backoff.dart';
import '../../domain/entities/maintenance_info.dart';
import '../../domain/repositories/maintenance_repository.dart';
import '../datasources/maintenance_remote_data_source.dart';

final class MaintenanceRepositoryImpl implements MaintenanceRepository {
  const MaintenanceRepositoryImpl(
    this._remote, {
    Backoff backoff = const Backoff(),
  }) : _backoff = backoff;

  final MaintenanceRemoteDataSource _remote;
  final Backoff _backoff;

  @override
  Stream<MaintenanceInfo> watchMaintenance() => _remote.watchMaintenance();

  @override
  Stream<MaintenanceInfo> pollUntilUp(MaintenanceInfo info) async* {
    var attempt = 0;
    var wait = info.retryAfter ?? _backoff.delay(attempt);
    while (true) {
      await Future<void>.delayed(wait);
      try {
        final latest = await _remote.checkHealth();
        if (latest == null) return;
        yield latest;
      } on Failure catch (_) {}
      attempt++;
      wait = _backoff.delay(attempt);
    }
  }

  @override
  void reconnectRealtime() => _remote.reconnectRealtime();
}
