import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/no_data_found_widget.dart';
import '../../domain/entities/maintenance_info.dart';
import 'maintenance_since_text.dart';

class MaintenanceView extends StatelessWidget {
  const MaintenanceView({required this.info, super.key});

  final MaintenanceInfo info;

  @override
  Widget build(BuildContext context) {
    final since = info.since;
    return NoDataFoundWidget(
      icon: AppAssets.maintenance,
      title: info.reason.label,
      message: info.message,
      action: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (since != null) ...[
            MaintenanceSinceText(since: since),
            const SizedBox(height: AppDimensions.spaceXs),
          ],
          const Text(
            AppStrings.maintenanceAutoRecover,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          const SizedBox.square(
            dimension: AppDimensions.progressSm,
            child: CircularProgressIndicator(
              strokeWidth: AppDimensions.progressStroke,
            ),
          ),
        ],
      ),
    );
  }
}
