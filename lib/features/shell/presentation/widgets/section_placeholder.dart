import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/no_data_found_widget.dart';
import '../navigation/nav_destination.dart';

class SectionPlaceholder extends StatelessWidget {
  const SectionPlaceholder({required this.destination, super.key});

  final NavDestination destination;

  @override
  Widget build(BuildContext context) {
    return NoDataFoundWidget(
      icon: destination.icon,
      title: destination.label,
      message: AppStrings.sectionComingSoon,
    );
  }
}
