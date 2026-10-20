import 'token_storage.dart';

final class InMemoryTokenStorage implements TokenStorage {
  String? _token;

  @override
  Future<String?> getToken() async => _token;

  @override
  Future<void> saveToken(String token) async {
    if (token.isNotEmpty) _token = token;
  }

  @override
  Future<void> deleteToken() async => _token = null;
}
