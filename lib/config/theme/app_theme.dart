import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Material 3 theme. Sizes are plain logical pixels: the console is a
/// desktop-width web app, so no screen-size scaling.
abstract final class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
