import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_styles.dart';


abstract final class AppSnackBar {
  static void showError(BuildContext context, String message) =>
      _show(context, message, AppColors.snackBarError);

  static void showSuccess(BuildContext context, String message) =>
      _show(context, message, AppColors.snackBarSuccess);

  static void _show(BuildContext context, String message, Color background) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: AppStyles.snackBarText),
          backgroundColor: background,
          duration: AppStyles.snackBarDuration,
        ),
      );
  }
}
