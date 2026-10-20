import 'package:flutter/material.dart';

import '../navigation/nav_destination.dart';

class WebNavigation extends StatelessWidget {
  const WebNavigation({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<NavDestination> destinations;

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
