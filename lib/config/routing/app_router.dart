import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../features/auth/domain/entities/permission.dart';
import '../../features/auth/domain/services/session_access.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/widgets/permission_gate.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/shell/presentation/navigation/nav_destination.dart';
import '../../features/shell/presentation/navigation/nav_destinations.dart';
import '../../features/shell/presentation/pages/shell_page.dart';
import '../../features/shell/presentation/widgets/no_access_view.dart';
import '../../features/shell/presentation/widgets/section_placeholder.dart';
import '../../features/trips/presentation/pages/trip_detail_page.dart';
import '../../features/trips/presentation/pages/trips_page.dart';
import '../../shared/pages/not_found_page.dart';
import 'route_names.dart';


final class AppRouter {
  AppRouter({required SessionAccess session}) : _session = session;

  final SessionAccess _session;
  final navigatorKey = GlobalKey<NavigatorState>();

  Route<void> onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? RouteNames.kRootPage;
    if (!_session.isSignedIn) {
      return _route(RouteNames.kSignIn, const SignInPage());
    }
    if (name == RouteNames.kRootPage || name == RouteNames.kSignIn) {
      return _homeRoute();
    }
    if (name == RouteNames.kTripDetail) return _tripDetailRoute(settings);

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
    return _route(RouteNames.kRootPage, const ShellPage.noSections());
  }

  static Route<void> _sectionRoute(NavDestination destination) =>
      PageRouteBuilder<void>(
        settings: RouteSettings(name: destination.route),
        pageBuilder: (_, _, _) => ShellPage.section(
          destination: destination,
          page: _sectionPage(destination),
        ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );

  static Route<void> _tripDetailRoute(RouteSettings settings) {
    final tripId = settings.arguments;
    if (tripId is! String) {
      return _route(
        RouteNames.kTripDetail,
        const NotFoundPage(path: RouteNames.kTripDetail),
      );
    }
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => PermissionGate(
        permission: TripPermission.read,
        fallback: const Scaffold(body: NoAccessView.section(AppStrings.trips)),
        child: TripDetailPage(tripId: tripId),
      ),
    );
  }

  static Widget _sectionPage(NavDestination destination) {
    if (destination == NavDestinations.dashboard) return const DashboardPage();
    if (destination == NavDestinations.trips) return const TripsPage();
    return SectionPlaceholder(destination: destination);
  }

  static Route<void> _route(String name, Widget page) =>
      MaterialPageRoute<void>(
        settings: RouteSettings(name: name),
        builder: (_) => page,
      );
}
