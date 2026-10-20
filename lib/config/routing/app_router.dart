import 'package:flutter/material.dart';

import '../../features/auth/domain/services/session_access.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/shell/presentation/navigation/nav_destination.dart';
import '../../features/shell/presentation/navigation/nav_destinations.dart';
import '../../features/shell/presentation/pages/shell_page.dart';
import '../../shared/pages/not_found_page.dart';
import 'route_names.dart';


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


  List<Route<void>> onGenerateInitialRoutes(String initialRoute) => [
    onGenerateRoute(RouteSettings(name: initialRoute)),
  ];

  void showConsole() => _resetTo(RouteNames.kRootPage);
  void showSignIn() => _resetTo(RouteNames.kSignIn);

  void _resetTo(String name) =>
      navigatorKey.currentState?.pushNamedAndRemoveUntil(name, (_) => false);

  Route<void> _homeRoute() {
    for (final destination in NavDestinations.all) {
      if (_session.can(destination.permission)) {
        return _sectionRoute(destination);
      }
    }
    return _route(RouteNames.kRootPage, const ShellPage());
  }

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
