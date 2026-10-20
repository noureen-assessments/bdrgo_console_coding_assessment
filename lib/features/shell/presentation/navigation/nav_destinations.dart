import '../../../../config/routing/route_names.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/domain/entities/permission.dart';
import '../../../auth/domain/entities/permissions.dart';
import 'nav_destination.dart';

/// Registry of every console section, in menu order. Adding a section is
/// one entry in [all]; the router, the menus and the no-access page all
/// read from here.
///
/// Access comes from each entry's permission, never from the role.
abstract final class NavDestinations {
  static const dashboard = NavDestination(
    route: RouteNames.kDashboard,
    label: AppStrings.dashboard,
    icon: AppAssets.dashboard,
    permission: KpiPermission.read,
  );

  static const trips = NavDestination(
    route: RouteNames.kTrips,
    label: AppStrings.trips,
    icon: AppAssets.trips,
    permission: TripPermission.read,
  );

  static const liveMap = NavDestination(
    route: RouteNames.kLiveMap,
    label: AppStrings.liveMap,
    icon: AppAssets.liveMap,
    permission: DriverPermission.track,
  );

  static const alerts = NavDestination(
    route: RouteNames.kAlerts,
    label: AppStrings.alerts,
    icon: AppAssets.alerts,
    permission: AlertPermission.read,
  );

  static const all = [dashboard, trips, liveMap, alerts];

  /// The section at [route], or null when [route] is not a section.
  static NavDestination? findByRoute(String route) {
    for (final destination in all) {
      if (destination.route == route) return destination;
    }
    return null;
  }

  /// The sections [permissions] allow, in menu order.
  static List<NavDestination> allowedFor(Permissions permissions) {
    final allowed = <NavDestination>[];
    for (final destination in all) {
      if (permissions.can(destination.permission)) allowed.add(destination);
    }
    return allowed;
  }
}
