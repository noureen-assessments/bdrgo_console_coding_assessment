import 'package:badrgo_console_assesment/config/flavor/flavor_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlavorValues.fromApiUrl', () {
    test('splits protocol and host', () {
      final values = FlavorValues.fromApiUrl('https://api.example.com');

      expect(values.baseProtocol, 'https');
      expect(values.baseHost, 'api.example.com');
      expect('${values.baseUri}', 'https://api.example.com');
    });

    test('keeps port and path prefix in the host', () {
      final values = FlavorValues.fromApiUrl('http://localhost:8080/v1');

      expect(values.baseProtocol, 'http');
      expect(values.baseHost, 'localhost:8080/v1');
    });

    test('rejects values that are not absolute http(s) URLs', () {
      expect(
        () => FlavorValues.fromApiUrl('api.example.com'),
        throwsArgumentError,
      );
      expect(() => FlavorValues.fromApiUrl('ftp://host'), throwsArgumentError);
    });
  });

  test('FlavorConfig exposes the latest flavor through its helpers', () {
    final values = FlavorValues.fromApiUrl('https://api.example.com');

    final alpha = FlavorConfig(flavor: Flavor.ALPHA, values: values);
    expect(FlavorConfig.instance, same(alpha));
    expect(alpha.name, 'ALPHA');
    expect(FlavorConfig.isAlpha(), isTrue);
    expect(FlavorConfig.isProduction(), isFalse);

    FlavorConfig(flavor: Flavor.PROD, values: values);
    expect(FlavorConfig.isProduction(), isTrue);
    expect(FlavorConfig.isDevelopment(), isFalse);
  });
}
