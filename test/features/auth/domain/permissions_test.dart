import 'package:badrgo_console_assesment/features/auth/domain/entities/permission.dart';
import 'package:badrgo_console_assesment/features/auth/domain/entities/permissions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const permissions = Permissions({
    TripPermission.read,
    TripPermission.assign,
    KpiPermission.read,
  });

  test('grants only the listed permissions', () {
    expect(permissions.can(TripPermission.assign), isTrue);
    expect(permissions.can(KpiPermission.read), isTrue);
    expect(permissions.can(TripPermission.cancel), isFalse);
    expect(permissions.can(DriverPermission.track), isFalse);
  });

  test('the same action on another resource is a different permission', () {
    expect(permissions.can(DriverPermission.read), isFalse);
  });

  test('none grants nothing', () {
    expect(Permissions.none.can(TripPermission.read), isFalse);
  });
}
