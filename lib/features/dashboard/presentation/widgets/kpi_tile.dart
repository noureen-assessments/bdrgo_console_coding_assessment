import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';

class KpiTile extends StatelessWidget {
  const KpiTile({
    required this.label,
    required this.icon,
    required this.value,
    required this.detail,
    super.key,
  });

  final String label;
  final IconData icon;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: AppDimensions.iconMd),
                const SizedBox(width: AppDimensions.spaceXs),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.body,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(value, style: AppTextStyles.kpiValue),
            ),
            const SizedBox(height: AppDimensions.spaceXxs),
            Text(
              detail,
              style: AppTextStyles.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
