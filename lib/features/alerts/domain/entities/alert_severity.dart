import 'dart:ui';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

enum AlertSeverity {
  info('info', AppStrings.alertInfo, AppColors.alertInfo),
  warning('warning', AppStrings.alertWarning, AppColors.alertWarning),
  critical('critical', AppStrings.alertCritical, AppColors.alertCritical);

  const AlertSeverity(this.value, this.label, this.color);

  final String value;
  final String label;
  final Color color;

  static AlertSeverity fromValue(String value) {
    final lower = value.toLowerCase();
    for (final severity in values) {
      if (severity.value == lower) return severity;
    }
    throw FormatException('alert severity', value);
  }
}
