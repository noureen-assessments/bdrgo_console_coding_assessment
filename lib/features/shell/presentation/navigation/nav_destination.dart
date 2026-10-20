import 'package:flutter/widgets.dart';

import '../../../auth/domain/entities/permission.dart';

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
