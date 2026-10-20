import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_styles.dart';


abstract final class AppStyles {
  static const animationDuration = Duration(milliseconds: 200);

  /// Full-width primary action (sign in, retry).
  static final primaryButton = FilledButton.styleFrom(
    minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
  );

  static const inputBorder = OutlineInputBorder();

  static BoxDecoration notice({required bool isError}) => BoxDecoration(
    color: isError ? AppColors.errorBackground : AppColors.infoBackground,
    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
  );

  static TextStyle noticeText({required bool isError}) =>
      AppTextStyles.body.copyWith(color: noticeForeground(isError: isError));

  static Color noticeForeground({required bool isError}) =>
      isError ? AppColors.onErrorBackground : AppColors.onInfoBackground;

  static BoxDecoration statusDot({required bool isLive}) => BoxDecoration(
    color: isLive ? AppColors.live : AppColors.reconnecting,
    shape: BoxShape.circle,
  );

  static final snackBarText = AppTextStyles.body.copyWith(
    color: AppColors.onSnackBar,
  );

  static const snackBarDuration = Duration(seconds: 4);
}
