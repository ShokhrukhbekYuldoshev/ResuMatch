import 'package:flutter/material.dart';
import 'package:resumatch/core/constants/colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: BrandColors.bgLight,
    colorScheme: const ColorScheme.light(
      primary: BrandColors.primaryBlue,
      secondary: BrandColors.accentPurple,
      surface: BrandColors.surfaceLight,
      onSurface: BrandColors.textPrimaryLight,
      error: BrandColors.error,
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: BrandColors.bgDark,
    colorScheme: const ColorScheme.dark(
      primary: BrandColors.primaryBlue,
      secondary: BrandColors.accentPurple,
      surface: BrandColors.surfaceDark,
      onSurface: BrandColors.textPrimaryDark,
      error: BrandColors.error,
    ),
  );
}
