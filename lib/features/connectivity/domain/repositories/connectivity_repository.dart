/// Whether the device has a network connection. Blocs use it to tell the
/// user they are offline and to retry once the connection is back.
abstract interface class ConnectivityRepository {
  Future<bool> isOnline();

  /// Emits only on changes: `false` when the connection drops, `true` when
  /// it comes back.
  Stream<bool> watchOnline();
}
