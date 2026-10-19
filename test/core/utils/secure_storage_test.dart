import 'package:badrgo_console_assesment/core/storage/storage_keys.dart';
import 'package:badrgo_console_assesment/core/utils/secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('with the platform storage', () {
    setUp(() => FlutterSecureStorage.setMockInitialValues({}));

    test('saves, reads and deletes the token', () async {
      final storage = AppSecureStorage();

      await storage.saveToken('jwt-1');
      expect(await storage.getToken(), 'jwt-1');
      expect(await AppSecureStorage().getToken(), 'jwt-1', reason: 'persisted');

      await storage.deleteToken();
      expect(await storage.getToken(), isNull);
      expect(await AppSecureStorage().getToken(), isNull);
    });

    test('ignores an empty token', () async {
      final storage = AppSecureStorage();
      await storage.saveToken('jwt-1');

      await storage.saveToken('');

      expect(await storage.getToken(), 'jwt-1');
    });

    test('deleteAll clears the cached token too', () async {
      final storage = AppSecureStorage();
      await storage.saveToken('jwt-1');

      await storage.deleteAll();

      expect(await storage.getToken(), isNull);
    });
  });

  group('with a failing platform', () {
    late _MockStorage platform;
    late AppSecureStorage storage;

    setUp(() {
      platform = _MockStorage();
      storage = AppSecureStorage(storage: platform);
      when(
        () => platform.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});
    });

    test(
      'retries a write_failed write after deleting the stale entry',
      () async {
        var calls = 0;
        when(
          () => platform.write(key: StorageKeys.token, value: 'jwt-1'),
        ).thenAnswer((_) async {
          if (calls++ == 0) throw PlatformException(code: 'write_failed');
        });

        await storage.saveToken('jwt-1');

        verify(() => platform.delete(key: StorageKeys.token)).called(1);
        expect(calls, 2);
        expect(await storage.getToken(), 'jwt-1');
      },
    );

    test('a read error returns null instead of throwing', () async {
      when(
        () => platform.read(key: StorageKeys.token),
      ).thenThrow(PlatformException(code: 'read_failed'));

      expect(await storage.getToken(), isNull);
    });
  });

  test('sanitizeError masks JWTs and emails', () {
    final sanitized = AppSecureStorage.sanitizeError(
      Exception('bad token eyJhbGciOi.eyJzdWIiOi.c2lnbmF0 for ops@demo.test'),
    ).toString();

    expect(sanitized, isNot(contains('eyJ')));
    expect(sanitized, isNot(contains('ops@demo.test')));
  });
}
