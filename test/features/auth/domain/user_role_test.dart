import 'package:badrgo_console_assesment/features/auth/domain/entities/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromValue reads every API role name', () {
    expect(UserRole.fromValue('super_admin'), UserRole.superAdmin);
    expect(UserRole.fromValue('ops_manager'), UserRole.opsManager);
    expect(UserRole.fromValue('dispatcher'), UserRole.dispatcher);
    expect(UserRole.fromValue('support'), UserRole.support);
    expect(UserRole.fromValue('viewer'), UserRole.viewer);
  });

  test('a role the app does not know is unknown', () {
    expect(UserRole.fromValue('auditor'), UserRole.unknown);
  });
}
