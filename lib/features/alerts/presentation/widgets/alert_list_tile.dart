import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_styles.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../domain/entities/alert.dart';
import 'alert_severity_badge.dart';

class AlertListTile extends StatelessWidget {
  const AlertListTile({required this.alert, super.key});

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: alert.isAcknowledged ? AppStyles.acknowledgedOpacity : 1,
      child: ListTile(
        leading: AlertSeverityBadge(severity: alert.severity),
        title: Text(alert.type.label, style: AppTextStyles.title),
        subtitle: Text(
          alert.message,
          style: AppTextStyles.caption,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormatters.dayTime(alert.createdAt),
              style: AppTextStyles.caption,
            ),
            if (alert.isAcknowledged) ...[
              const SizedBox(height: AppDimensions.spaceXxs),
              const Text(
                AppStrings.alertAcknowledged,
                style: AppTextStyles.caption,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
