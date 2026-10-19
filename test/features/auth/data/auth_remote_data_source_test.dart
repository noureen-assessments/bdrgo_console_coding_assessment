import 'package:badrgo_console_assesment/core/network/api_consumer.dart';
import 'package:badrgo_console_assesment/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../auth_fixtures.dart';

class _MockApi extends Mock implements ApiConsumer {}

void main() {
  late _MockApi api;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    api = _MockApi();
    dataSource = AuthRemoteDataSourceImpl(api);
  });

  test('fetchMe parses the profile', () async {
    when(() => api.get('/api/me')).thenAnswer((_) async => meJson());

    final model = await dataSource.fetchMe();

    expect(model.name, 'Dana Dispatcher');
  });

  test('fetchMe reports a malformed body as FormatException', () {
    when(() => api.get('/api/me')).thenAnswer((_) async => {'role': 'viewer'});

    expect(dataSource.fetchMe(), throwsFormatException);
  });
}
