import 'package:badrgo_console_assesment/features/auth/domain/entities/permissions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const permissions = Permissions({
    'trip': {'read', 'assign'},
    'kpi': {'read'},
  });

  test('grants only the listed actions on the listed resources', () {
    expect(permissions.can('trip', 'assign'), isTrue);
    expect(permissions.can('kpi', 'read'), isTrue);
    expect(permissions.can('trip', 'cancel'), isFalse);
    expect(permissions.can('driver', 'track'), isFalse);
  });

  test('none grants nothing', () {
    expect(Permissions.none.can('trip', 'read'), isFalse);
  });
}
