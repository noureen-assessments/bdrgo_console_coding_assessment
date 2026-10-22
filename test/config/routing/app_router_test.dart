import 'package:badrgo_console_assesment/config/routing/app_router.dart';
import 'package:badrgo_console_assesment/features/auth/domain/entities/permissions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../features/auth/auth_fixtures.dart';
import '../../features/fakes.dart';

void main() {
  String? urlFor(String path, Permissions? permissions) {
    final router = AppRouter(session: FakeSessionAccess(permissions));
    return router.onGenerateRoute(RouteSettings(name: path)).settings.name;
  }

  test('signed out, every URL shows sign-in', () {
    expect(urlFor('/trips', null), '/sign-in');
    expect(urlFor('/', null), '/sign-in');
  });

  group('home opens the first section the user may open', () {
    test('viewer lands on the dashboard', () {
      expect(urlFor('/', viewerPermissions), '/dashboard');
    });

    test('support (no kpi:read) lands on trips', () {
      expect(urlFor('/', supportPermissions), '/trips');
    });

    test('right after sign-in too', () {
      expect(urlFor('/sign-in', supportPermissions), '/trips');
    });

    test('no permissions stays on / (no-access page)', () {
      expect(urlFor('/', Permissions.none), '/');
    });
  });

  test('a section the user may not open keeps its URL (no-access page)', () {
    expect(urlFor('/live-map', viewerPermissions), '/live-map');
  });

  test('an unknown URL keeps its URL (not-found page)', () {
    expect(urlFor('/nope', viewerPermissions), '/nope');
  });
}
