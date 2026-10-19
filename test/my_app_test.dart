import 'dart:async';

import 'package:badrgo_console_assesment/config/flavor/flavor_config.dart';
import 'package:badrgo_console_assesment/config/routing/app_router.dart';
import 'package:badrgo_console_assesment/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(AppRouter router, {Flavor flavor = Flavor.PROD}) => MyApp(
  router: router,
  flavorConfig: FlavorConfig(
    flavor: flavor,
    values: FlavorValues.fromApiUrl('https://api.example.com'),
  ),
);

void main() {
  testWidgets('unknown route shows not-found and Go home resets the stack', (
    tester,
  ) async {
    final router = AppRouter();
    await tester.pumpWidget(_app(router));

    expect(find.text('Project setup complete'), findsOneWidget);

    unawaited(router.navigatorKey.currentState!.pushNamed('/does-not-exist'));
    await tester.pumpAndSettle();

    expect(find.text('Page not found'), findsOneWidget);
    expect(find.text('/does-not-exist'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Go home'));
    await tester.pumpAndSettle();

    expect(find.text('Project setup complete'), findsOneWidget);
    expect(router.navigatorKey.currentState!.canPop(), isFalse);
  });

  test('a deep link opens only the requested page', () {
    final routes = AppRouter().onGenerateInitialRoutes('/trips/42');

    expect(routes, hasLength(1));
    expect(routes.single.settings.name, '/trips/42');
  });

  testWidgets('shows the flavor banner except in prod', (tester) async {
    await tester.pumpWidget(_app(AppRouter(), flavor: Flavor.DEV));
    expect(tester.widget<Banner>(find.byType(Banner)).message, 'DEV');

    await tester.pumpWidget(_app(AppRouter(), flavor: Flavor.ALPHA));
    expect(tester.widget<Banner>(find.byType(Banner)).message, 'ALPHA');

    await tester.pumpWidget(_app(AppRouter()));
    expect(find.byType(Banner), findsNothing);
  });
}
