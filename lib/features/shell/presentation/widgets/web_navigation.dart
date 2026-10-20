import 'package:flutter/material.dart';

import '../navigation/nav_destination.dart';

/// Side menu for web (wider than phone) windows: each icon with its label
/// beside it.
class WebNavigation extends StatelessWidget {
  const WebNavigation({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  /// Only the sections the user may open.
  final List<NavDestination> destinations;

  /// Null when the open page is not in [destinations] (e.g. no access).
  final int? selectedIndex;
  final ValueChanged<NavDestination> onSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: true,
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => onSelected(destinations[index]),
      destinations: [
        for (final destination in destinations)
          NavigationRailDestination(
            icon: Icon(destination.icon),
            label: Text(destination.label),
          ),
      ],
    );
  }
}
