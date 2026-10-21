import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_styles.dart';
import '../../domain/entities/alert_severity.dart';

class AlertSeverityBadge extends StatelessWidget {
  const AlertSeverityBadge({required this.severity, super.key});

  final AlertSeverity severity;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppStyles.severityBadge(severity.color),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceXs,
          vertical: AppDimensions.spaceXxs,
        ),
        child: Text(
          severity.label,
          style: AppStyles.severityBadgeText(severity.color),
        ),
      ),
    );
  }
}
