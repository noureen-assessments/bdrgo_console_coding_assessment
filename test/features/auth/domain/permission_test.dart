import 'package:badrgo_console_assesment/features/auth/domain/entities/permission.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('each action belongs to the resource that lists it', () {
    for (final resource in PermissionResource.values) {
      for (final action in resource.actions) {
        expect(action.resource, resource, reason: '${resource.value}:$action');
      }
    }
  });

  test('looks up resources and actions by their API names', () {
    expect(PermissionResource.fromValue('user'), PermissionResource.user);
    expect(PermissionResource.user.action('set-role'), UserPermission.setRole);
    expect(PermissionResource.fromValue('report'), isNull);
    expect(PermissionResource.kpi.action('ban'), isNull);
  });
}
