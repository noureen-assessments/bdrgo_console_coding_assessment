import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_styles.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../domain/entities/driver_status.dart';

class DriverStatusLegend extends StatelessWidget {
  const DriverStatusLegend({super.key});

  static const _shown = [DriverStatus.available, DriverStatus.onTrip];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceSm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final status in _shown) _LegendItem(status: status),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.status});

  final DriverStatus status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceXxs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: AppStyles.legendDot(status.color),
            child: const SizedBox.square(dimension: AppDimensions.statusDot),
          ),
          const SizedBox(width: AppDimensions.spaceXs),
          Text(status.label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
