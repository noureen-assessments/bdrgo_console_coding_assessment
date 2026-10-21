import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_styles.dart';
import '../../../../config/theme/app_text_styles.dart';

class KpiTile extends StatelessWidget {
  const KpiTile({
    required this.label,
    required this.accent,
    required this.value,
    required this.detail,
    super.key,
  });

  final String label;
  final Color accent;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: AppStyles.dashboardCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: accent,
            child: const SizedBox(height: AppDimensions.kpiAccentBar),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceLg),
            child: Column(
              children: [
                Text(
                  label,
                  style: AppStyles.mutedLabel,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.spaceXs),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: AppTextStyles.kpiValue,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXxs),
                Text(
                  detail,
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
