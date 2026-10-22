import 'package:badrgo_console_assesment/core/storage/in_memory_token_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('keeps the token for this page only', () async {
    final storage = InMemoryTokenStorage();

    await storage.saveToken('jwt-1');
    expect(await storage.getToken(), 'jwt-1');
    expect(
      await InMemoryTokenStorage().getToken(),
      isNull,
      reason: 'a new page (refresh) starts empty; the cookie restores it',
    );

    await storage.deleteToken();
    expect(await storage.getToken(), isNull);
  });

  test('ignores an empty token', () async {
    final storage = InMemoryTokenStorage();
    await storage.saveToken('jwt-1');

    await storage.saveToken('');

    expect(await storage.getToken(), 'jwt-1');
  });
}
