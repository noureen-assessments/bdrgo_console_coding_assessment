import 'package:flutter/material.dart';

import '../../config/theme/app_dimensions.dart';
import '../../config/theme/app_styles.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.label, required this.color, super.key});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppStyles.statusBadge(color),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceXs,
          vertical: AppDimensions.spaceXxs,
        ),
        child: Text(label, style: AppStyles.statusBadgeText(color)),
      ),
    );
  }
}
