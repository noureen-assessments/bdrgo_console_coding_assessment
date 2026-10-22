import 'package:badrgo_console_assesment/features/auth/domain/entities/permission.dart';
import 'package:badrgo_console_assesment/features/auth/domain/entities/permissions.dart';
import 'package:badrgo_console_assesment/features/shell/presentation/navigation/nav_destinations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../auth/auth_fixtures.dart';

void main() {
  group('allowedFor follows the permissions, in menu order', () {
    test('dispatcher: every section', () {
      expect(NavDestinations.allowedFor(dispatcherPermissions), [
        NavDestinations.dashboard,
        NavDestinations.trips,
        NavDestinations.liveMap,
        NavDestinations.alerts,
      ]);
    });

    test('viewer: no live map', () {
      expect(NavDestinations.allowedFor(viewerPermissions), [
        NavDestinations.dashboard,
        NavDestinations.trips,
        NavDestinations.alerts,
      ]);
    });

    test('support: no dashboard and no live map', () {
      expect(NavDestinations.allowedFor(supportPermissions), [
        NavDestinations.trips,
        NavDestinations.alerts,
      ]);
    });

    test('no permissions: nothing', () {
      expect(NavDestinations.allowedFor(Permissions.none), isEmpty);
    });

    test('an action alone does not open its section', () {
      const assignOnly = Permissions({TripPermission.assign});

      expect(NavDestinations.allowedFor(assignOnly), isEmpty);
    });
  });

  group('findByRoute', () {
    test('finds a section by its URL', () {
      expect(NavDestinations.findByRoute('/live-map'), NavDestinations.liveMap);
    });

    test('null for a URL that is not a section', () {
      expect(NavDestinations.findByRoute('/nope'), isNull);
    });
  });

  test('every section has its own URL', () {
    final routes = NavDestinations.all.map((d) => d.route).toSet();

    expect(routes, hasLength(NavDestinations.all.length));
  });
}
