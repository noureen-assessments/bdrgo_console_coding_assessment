import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_styles.dart';
import 'app_text_styles.dart';

/// Material 3 theme assembled from [AppColors], [AppTextStyles] and
/// [AppStyles]. Layout adapts to the window width (see `ResponsiveContext`).
abstract final class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    textTheme: AppTextStyles.textTheme,
    inputDecorationTheme: const InputDecorationTheme(
      border: AppStyles.inputBorder,
    ),
    filledButtonTheme: FilledButtonThemeData(style: AppStyles.primaryButton),
  );
}
