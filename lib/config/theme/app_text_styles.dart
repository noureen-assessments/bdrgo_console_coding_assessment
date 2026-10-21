import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  static const fontFamily = 'ClashGrotesk';

  static const headline = TextStyle(
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w400,
  );

  static const headlineCompact = TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w500,
  );

  static const kpiValue = TextStyle(
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w500,
  );

  static const title = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w500,
  );

  static const body = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
  );

  static const caption = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );

  static const textTheme = TextTheme(
    headlineSmall: headline,
    titleMedium: title,
    bodyMedium: body,
    bodySmall: caption,
  );
}
