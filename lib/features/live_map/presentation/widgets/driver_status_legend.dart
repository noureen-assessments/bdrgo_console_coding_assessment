import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../domain/entities/driver_status.dart';
import 'driver_status_label.dart';

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
            for (final status in _shown)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spaceXxs,
                ),
                child: DriverStatusLabel(status: status),
              ),
          ],
        ),
      ),
    );
  }
}
