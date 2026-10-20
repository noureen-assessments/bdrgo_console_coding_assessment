import 'package:flutter/material.dart';

/// Every color the app uses. Widgets never write `Color(...)` or read
/// ad-hoc theme colors; they use these names.
abstract final class AppColors {
  static const primary = Color(0xFF0B6E4F);

  // Error notices: sign-in errors, offline banner.
  static const errorBackground = Color(0xFFFFDAD6);
  static const onErrorBackground = Color(0xFF93000A);

  // Neutral notices, e.g. "your session has ended".
  static const infoBackground = Color(0xFFD0E8DC);
  static const onInfoBackground = Color(0xFF0C3B2B);

  // Live status: updates flowing, or reconnecting.
  static const live = Color(0xFF1E8E3E);
  static const reconnecting = Color(0xFFB26A00);

  // Snackbars
  static const snackBarError = Color(0xFFBA1A1A);
  static const snackBarSuccess = Color(0xFF0B6E4F);
  static const onSnackBar = Color(0xFFFFFFFF);
}
