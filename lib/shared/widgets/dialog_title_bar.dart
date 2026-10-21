import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimensions.dart';
import '../../config/theme/app_styles.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_strings.dart';

class DialogTitleBar extends StatelessWidget {
  const DialogTitleBar({required this.title, this.onClose, super.key});

  final String title;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: AppDimensions.spaceLg,
          end: AppDimensions.spaceXs,
          top: AppDimensions.spaceXs,
          bottom: AppDimensions.spaceXs,
        ),
        child: Row(
          children: [
            Expanded(child: Text(title, style: AppStyles.dialogTitle)),
            IconButton(
              icon: const Icon(AppAssets.close),
              color: AppColors.onPrimary,
              tooltip: AppStrings.close,
              onPressed: onClose,
            ),
          ],
        ),
      ),
    );
  }
}
