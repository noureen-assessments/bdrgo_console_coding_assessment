import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_styles.dart';
import '../../domain/entities/trip_status.dart';

class TripStatusBadge extends StatelessWidget {
  const TripStatusBadge({required this.status, super.key});

  final TripStatus status;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppStyles.statusBadge,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceXs,
          vertical: AppDimensions.spaceXxs,
        ),
        child: Text(status.label, style: AppStyles.statusBadgeText),
      ),
    );
  }
}
