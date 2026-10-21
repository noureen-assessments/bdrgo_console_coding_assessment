import 'package:flutter/material.dart';

import '../../config/theme/app_dimensions.dart';
import '../../config/theme/app_styles.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.label, required this.color, this.width, super.key,});

  final String label;
  final Color color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final badge = DecoratedBox(
      decoration: AppStyles.statusBadge(color),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceXs,
          vertical: AppDimensions.spaceXxs,
        ),
        child: Text(label, style: AppStyles.statusBadgeText(color), textAlign: TextAlign.center,),
      ),
    );
    final width = this.width;
    if (width == null) return badge;
    return SizedBox(width: width, child: badge);
  }
}
