import 'package:flutter/material.dart';

import '../../shared/pages/not_found_page.dart';
import '../../shared/pages/setup_page.dart';
import 'route_names.dart';

/// Navigator-based routing with named routes. On web the route name is the
/// browser URL, so a deep link or refresh lands on the same page.
///
/// A class rather than globals so tests get a fresh instance, and so auth
/// and permission guards can be added in [onGenerateRoute] later.
final class AppRouter {
  AppRouter();

  /// Lets non-widget code (e.g. a session listener on 401) navigate.
  final navigatorKey = GlobalKey<NavigatorState>();

  Route<void> onGenerateRoute(RouteSettings settings) {
    final page = switch (settings.name) {
      RouteNames.kRootPage => const SetupPage(),
      final name => NotFoundPage(path: name ?? RouteNames.kRootPage),
    };
    return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
  }

  /// Opens only the requested URL. Flutter's default would also push every
  /// parent segment (`/`, `/trips`, `/trips/42`).
  List<Route<void>> onGenerateInitialRoutes(String initialRoute) => [
    onGenerateRoute(RouteSettings(name: initialRoute)),
  ];
}
