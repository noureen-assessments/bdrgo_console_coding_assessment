import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_styles.dart';
import '../../../../core/constants/app_assets.dart';
import '../../domain/entities/driver_location.dart';

class DriverMarker extends StatelessWidget {
  const DriverMarker({required this.driver, required this.onTap, super.key});

  final DriverLocation driver;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: driver.name,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: DecoratedBox(
          decoration: AppStyles.driverMarker(driver.status.color),
          child: const Center(
            child: Icon(
              AppAssets.driverMarker,
              size: AppDimensions.driverMarkerIcon,
              color: AppColors.onDriverMarker,
            ),
          ),
        ),
      ),
    );
  }
}
