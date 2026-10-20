
abstract interface class ConnectivityRepository {
  Future<bool> isOnline();
  Stream<bool> watchOnline();
}
