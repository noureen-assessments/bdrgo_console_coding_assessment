import 'dart:ui';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

enum DriverStatus {
  available('AVAILABLE', AppStrings.driverAvailable, AppColors.driverAvailable),
  onTrip('ON_TRIP', AppStrings.driverOnTrip, AppColors.driverOnTrip),
  offline('OFFLINE', AppStrings.driverOffline, AppColors.driverOffline);

  const DriverStatus(this.value, this.label, this.color);

  final String value;
  final String label;
  final Color color;

  static DriverStatus fromValue(String value) {
    final upper = value.toUpperCase();
    for (final status in values) {
      if (status.value == upper) return status;
    }
    throw FormatException('driver status', value);
  }
}
