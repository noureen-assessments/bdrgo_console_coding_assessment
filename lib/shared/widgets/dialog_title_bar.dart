import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimensions.dart';
import '../../config/theme/app_styles.dart';

class DialogTitleBar extends StatelessWidget {
  const DialogTitleBar({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceLg,
          vertical: AppDimensions.spaceMd,
        ),
        child: Text(title, style: AppStyles.dialogTitle),
      ),
    );
  }
}
