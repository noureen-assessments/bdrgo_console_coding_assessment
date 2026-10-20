import 'package:flutter/widgets.dart';

import '../../../auth/domain/entities/permission.dart';

/// One console section: its URL, how it looks in the menu and the one
/// permission it needs.
final class NavDestination {
  const NavDestination({
    required this.route,
    required this.label,
    required this.icon,
    required this.permission,
  });

  final String route;
  final String label;
  final IconData icon;
  final Permission permission;
}
