import '../constants/api_endpoints.dart';
import '../errors/failures.dart';
import '../network/api_consumer.dart';


abstract interface class SessionChecker {
  Future<void> check();
}

final class RestSessionChecker implements SessionChecker {
  const RestSessionChecker(this._api);

  final ApiConsumer _api;

  @override
  Future<void> check() async {
    try {
      await _api.get(ApiEndpoints.me);
    } on Failure catch (_) {}
  }
}
