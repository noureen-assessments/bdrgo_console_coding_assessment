import 'package:badrgo_console_assesment/core/network/api_urls.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiUrls', () {
    test('derives every transport URL from the https base URL', () {
      final urls = ApiUrls(Uri.parse('https://api.example.com/'));

      expect(urls.restBaseUrl, 'https://api.example.com');
      expect('${urls.graphql}', 'https://api.example.com/graphql');
      expect(
        '${urls.events(token: 'abc')}',
        'https://api.example.com/api/events?token=abc',
      );
      expect(
        '${urls.webSocket(token: 'abc')}',
        'wss://api.example.com/ws?token=abc',
      );
    });

    test('uses ws:// for http and keeps port and path prefix', () {
      final urls = ApiUrls(Uri.parse('http://localhost:8080/v1?x=1#f'));

      expect(urls.restBaseUrl, 'http://localhost:8080/v1');
      expect(
        '${urls.webSocket(token: 'abc')}',
        'ws://localhost:8080/v1/ws?token=abc',
      );
    });

    test('omits the token query for cookie-authenticated realtime', () {
      final urls = ApiUrls(Uri.parse('https://api.example.com'));

      expect('${urls.events()}', 'https://api.example.com/api/events');
      expect('${urls.webSocket(token: '')}', 'wss://api.example.com/ws');
    });

    test('encodes the token in the query string', () {
      final urls = ApiUrls(Uri.parse('https://api.example.com'));

      expect(urls.events(token: 'a+b/c=').queryParameters['token'], 'a+b/c=');
    });
  });
}
