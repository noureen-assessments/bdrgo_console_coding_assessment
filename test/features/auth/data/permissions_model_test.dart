import 'package:badrgo_console_assesment/features/auth/data/models/permissions_model.dart';
import 'package:badrgo_console_assesment/features/auth/domain/entities/permission.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final json = <String, dynamic>{
    'user': ['set-role', 'set-password', 'list'],
    'trip': ['read', 'assign'],
    'kpi': ['read'],
  };

  test('fromJson reads each resource and its actions', () {
    final model = PermissionsModel.fromJson(json);

    expect(model.granted, {
      UserPermission.setRole,
      UserPermission.setPassword,
      UserPermission.list,
      TripPermission.read,
      TripPermission.assign,
      KpiPermission.read,
    });
  });

  test('toJson round-trips through fromJson', () {
    final model = PermissionsModel.fromJson(json);

    expect(model.toJson(), json);
    expect(PermissionsModel.fromJson(model.toJson()), model);
  });

  test('skips resources and actions the app does not know', () {
    final model = PermissionsModel.fromJson({
      'report': ['read'],
      'trip': ['read', 'reroute'],
      'kpi': ['ban'],
    });

    expect(model.granted, {TripPermission.read});
  });

  test('an empty object grants nothing', () {
    expect(PermissionsModel.fromJson({}).granted, isEmpty);
  });
}
