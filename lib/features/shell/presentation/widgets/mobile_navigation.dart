import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../navigation/nav_destination.dart';

class MobileNavigation extends StatelessWidget {
  const MobileNavigation({
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
    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => onSelected(destinations[index]),
      children: [
        const SizedBox(height: AppDimensions.spaceMd),
        for (final destination in destinations)
          NavigationDrawerDestination(
            icon: Icon(destination.icon),
            label: Text(destination.label),
          ),
      ],
    );
  }
}
