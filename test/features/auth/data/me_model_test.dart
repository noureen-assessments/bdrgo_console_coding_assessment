import 'package:badrgo_console_assesment/features/auth/data/models/me_model.dart';
import 'package:badrgo_console_assesment/features/auth/domain/entities/current_user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../auth_fixtures.dart';

void main() {
  test('fromJson reads every field of /api/me', () {
    final model = MeModel.fromJson(meJson());

    expect(model.id, 'u1');
    expect(model.name, 'Dana Dispatcher');
    expect(model.email, 'dispatch.doha@demo.test');
    expect(model.role, 'dispatcher');
    expect(model.roleDescription, 'Assigns trips');
    expect(model.city?.id, 'city_doh');
    expect(model.city?.name, 'Doha');
    expect(model.permissions.can('trip', 'assign'), isTrue);
    expect(model.permissions.can('kpi', 'read'), isTrue);
    expect(model.permissions.can('trip', 'cancel'), isFalse);
  });

  test('is a CurrentUser, so the domain uses it directly', () {
    expect(MeModel.fromJson(meJson()), isA<CurrentUser>());
  });

  test('toJson round-trips through fromJson', () {
    final model = MeModel.fromJson(meJson());

    expect(MeModel.fromJson(model.toJson()), model);
  });

  test('super_admin has no city', () {
    final model = MeModel.fromJson({...meJson(), 'city': null});

    expect(model.city, isNull);
    expect(model.toJson()['city'], isNull);
  });

  test('a missing user fails the cast', () {
    expect(
      () => MeModel.fromJson({'role': 'viewer'}),
      throwsA(isA<TypeError>()),
    );
  });
}
