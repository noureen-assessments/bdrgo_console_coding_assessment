import 'package:flutter/material.dart';

import '../../features/auth/domain/services/session_access.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/shell/presentation/navigation/nav_destination.dart';
import '../../features/shell/presentation/navigation/nav_destinations.dart';
import '../../features/shell/presentation/pages/shell_page.dart';
import '../../shared/pages/not_found_page.dart';
import 'route_names.dart';

/// Navigator-based routing with named routes. On web the route name is the
/// browser URL, so a deep link or refresh lands on the same page.
///
/// Guards, in order:
/// 1. Signed out: every URL shows sign-in.
/// 2. `/` and `/sign-in`: the first section the user may open, so every
///    role lands on a page it can use.
/// 3. A section URL: the shell for that section. The shell itself shows
///    "no access" when the permission is missing, so the page also adapts
///    when permissions change while it is open.
/// 4. Anything else: not found.
///
/// The router only knows [SessionAccess], not how the session is stored.
final class AppRouter {
  AppRouter({required SessionAccess session}) : _session = session;

  final SessionAccess _session;

  /// Lets non-widget code (e.g. the session listener on 401) navigate.
  final navigatorKey = GlobalKey<NavigatorState>();

  Route<void> onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? RouteNames.kRootPage;
    if (!_session.isSignedIn) {
      return _route(RouteNames.kSignIn, const SignInPage());
    }
    if (name == RouteNames.kRootPage || name == RouteNames.kSignIn) {
      return _homeRoute();
    }

    final destination = NavDestinations.findByRoute(name);
    if (destination == null) return _route(name, NotFoundPage(path: name));
    return _sectionRoute(destination);
  }

  /// Opens only the requested URL. Flutter's default would also push every
  /// parent segment (`/`, `/trips`, `/trips/42`).
  List<Route<void>> onGenerateInitialRoutes(String initialRoute) => [
    onGenerateRoute(RouteSettings(name: initialRoute)),
  ];

  void showConsole() => _resetTo(RouteNames.kRootPage);

  /// Clears the whole stack, so no signed-in page (or its Blocs and
  /// realtime connections) outlives the session.
  void showSignIn() => _resetTo(RouteNames.kSignIn);

  void _resetTo(String name) =>
      navigatorKey.currentState?.pushNamedAndRemoveUntil(name, (_) => false);

  /// The first section the user may open (e.g. Trips for support, who has
  /// no dashboard). With none, the shell shows "no access".
  Route<void> _homeRoute() {
    for (final destination in NavDestinations.all) {
      if (_session.can(destination.permission)) {
        return _sectionRoute(destination);
      }
    }
    return _route(RouteNames.kRootPage, const ShellPage());
  }

  /// No page transition: picking a section in the web menu or the mobile
  /// drawer swaps the content at once.
  static Route<void> _sectionRoute(NavDestination destination) =>
      PageRouteBuilder<void>(
        settings: RouteSettings(name: destination.route),
        pageBuilder: (_, _, _) => ShellPage(destination: destination),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );

  /// The URL shows the page actually displayed, e.g. `/sign-in` after a
  /// redirect.
  static Route<void> _route(String name, Widget page) =>
      MaterialPageRoute<void>(
        settings: RouteSettings(name: name),
        builder: (_) => page,
      );
}
