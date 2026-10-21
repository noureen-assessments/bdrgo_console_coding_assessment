import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_styles.dart';


abstract final class AppStyles {
  static const animationDuration = Duration(milliseconds: 200);

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

  static BoxDecoration legendDot(Color color) =>
      BoxDecoration(color: color, shape: BoxShape.circle);

  static BoxDecoration driverMarker(Color color) => BoxDecoration(
    color: color,
    shape: BoxShape.circle,
    border: Border.all(
      color: AppColors.onDriverMarker,
      width: AppDimensions.driverMarkerBorder,
    ),
  );

  static BoxDecoration statusBadge(Color color) => BoxDecoration(
    border: Border.all(color: color),
    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
  );

  static TextStyle statusBadgeText(Color color) =>
      AppTextStyles.caption.copyWith(color: color);

  static const acknowledgedOpacity = 0.5;

  static final criticalBannerText = AppTextStyles.body.copyWith(
    color: AppColors.onAlertCritical,
  );

  static final criticalBannerButton = TextButton.styleFrom(
    foregroundColor: AppColors.onAlertCritical,
  );

  static final dashboardCard = BoxDecoration(
    color: AppColors.cardSurface,
    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
    boxShadow: const [
      BoxShadow(
        color: AppColors.cardShadow,
        blurRadius: AppDimensions.cardShadowBlur,
        offset: Offset(0, AppDimensions.cardShadowOffset),
      ),
    ],
  );

  static final mutedLabel = AppTextStyles.body.copyWith(
    color: AppColors.mutedText,
  );

  static final revenueValue = AppTextStyles.kpiValue.copyWith(
    color: AppColors.revenueValue,
    fontWeight: FontWeight.w700,
  );

  static final dialogTitle = AppTextStyles.title.copyWith(
    color: AppColors.onPrimary,
  );

  static final chartTooltipText = AppTextStyles.caption.copyWith(
    color: AppColors.onChartTooltip,
  );

  static final snackBarText = AppTextStyles.body.copyWith(
    color: AppColors.onSnackBar,
  );

  static const snackBarDuration = Duration(seconds: 4);

  static const elapsedTick = Duration(seconds: 30);
}
