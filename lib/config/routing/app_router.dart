import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/shell/presentation/pages/shell_page.dart';
import '../../shared/pages/not_found_page.dart';
import 'route_names.dart';

/// Navigator-based routing with named routes. On web the route name is the
/// browser URL, so a deep link or refresh lands on the same page.
///
/// Auth guard: signed out, every URL shows sign-in; signed in, `/sign-in`
/// shows the console. [isSignedIn] is a callback so the router does not
/// depend on how the session is stored.
final class AppRouter {
  AppRouter({required bool Function() isSignedIn}) : _isSignedIn = isSignedIn;

  final bool Function() _isSignedIn;

  /// Lets non-widget code (e.g. the session listener on 401) navigate.
  final navigatorKey = GlobalKey<NavigatorState>();

  Route<void> onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? RouteNames.kRootPage;
    if (!_isSignedIn()) return _route(RouteNames.kSignIn, const SignInPage());

    return switch (name) {
      RouteNames.kRootPage ||
      RouteNames.kSignIn => _route(RouteNames.kRootPage, const ShellPage()),
      _ => _route(name, NotFoundPage(path: name)),
    };
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

  /// The URL shows the page actually displayed, e.g. `/sign-in` after a
  /// redirect.
  static Route<void> _route(String name, Widget page) =>
      MaterialPageRoute<void>(
        settings: RouteSettings(name: name),
        builder: (_) => page,
      );
}
