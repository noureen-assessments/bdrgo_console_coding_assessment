import 'package:badrgo_console_assesment/features/auth/data/models/permissions_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final json = <String, dynamic>{
    'trip': ['read', 'assign'],
    'kpi': ['read'],
  };

  test('fromJson reads each resource and its actions', () {
    final model = PermissionsModel.fromJson(json);

    expect(model.grants, {
      'trip': {'read', 'assign'},
      'kpi': {'read'},
    });
    expect(model.can('trip', 'assign'), isTrue);
    expect(model.can('trip', 'cancel'), isFalse);
  });

  test('toJson round-trips through fromJson', () {
    final model = PermissionsModel.fromJson(json);

    expect(model.toJson(), json);
    expect(PermissionsModel.fromJson(model.toJson()), model);
  });

  test('an empty object grants nothing', () {
    expect(PermissionsModel.fromJson({}).can('kpi', 'read'), isFalse);
  });
}
