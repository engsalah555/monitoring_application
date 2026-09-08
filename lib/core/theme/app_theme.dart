import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Central Material 3 Theme Specification (Executive Dual Mode).
class AppTheme {
  const AppTheme._();

  static ThemeData get darkTheme {
    final baseDark = ThemeData.dark(useMaterial3: true);

    return baseDark.copyWith(
      scaffoldBackgroundColor: AppColors.bgPage,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.cyan,
        surface: AppColors.panel,
        error: AppColors.red,
      ),
      textTheme: baseDark.textTheme.apply(
        fontFamily: 'Cairo',
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.panel,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.panelLine),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    final baseLight = ThemeData.light(useMaterial3: true);

    return baseLight.copyWith(
      scaffoldBackgroundColor: AppColors.clayBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        surface: AppColors.clayCard,
        error: AppColors.red,
      ),
      textTheme: baseLight.textTheme.apply(
        fontFamily: 'Cairo',
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.clayCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.panelLine),
        ),
      ),
    );
  }
}
