import 'package:badrgo_console_assesment/config/env/env.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fails fast with a clear message when API_URL is not defined', () {
    expect(
      () => Env.apiUrl,
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          Env.missingApiUrl,
        ),
      ),
    );
  });

  group('WEB_AUTH_MODE', () {
    test('defaults to storage mode', () {
      expect(Env.parseWebAuthMode(''), WebAuthMode.storage);
    });

    test('accepts cookie and storage', () {
      expect(Env.parseWebAuthMode('cookie'), WebAuthMode.cookie);
      expect(Env.parseWebAuthMode('storage'), WebAuthMode.storage);
    });

    test('rejects unknown values instead of guessing', () {
      expect(() => Env.parseWebAuthMode('local'), throwsStateError);
    });

    test('never uses cookie mode off the web', () {
      expect(Env.usesHttpOnlyCookie, isFalse);
    });
  });
}
