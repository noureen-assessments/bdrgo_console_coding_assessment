import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_styles.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../domain/entities/driver_status.dart';

class DriverStatusLabel extends StatelessWidget {
  const DriverStatusLabel({required this.status, super.key});

  final DriverStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: AppStyles.legendDot(status.color),
          child: const SizedBox.square(dimension: AppDimensions.statusDot),
        ),
        const SizedBox(width: AppDimensions.spaceXs),
        Text(status.label, style: AppTextStyles.caption),
      ],
    );
  }
}
