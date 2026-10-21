import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_styles.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      surface: AppColors.surface,
    ),
    scaffoldBackgroundColor: AppColors.surface,
    cardTheme: const CardThemeData(color: AppColors.surface),
    dialogTheme: const DialogThemeData(backgroundColor: AppColors.surface),
    fontFamily: AppTextStyles.fontFamily,
    textTheme: AppTextStyles.textTheme,
    inputDecorationTheme: const InputDecorationTheme(
      border: AppStyles.inputBorder,
    ),
    filledButtonTheme: FilledButtonThemeData(style: AppStyles.primaryButton),
  );
}
