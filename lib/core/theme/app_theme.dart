import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Central Material 3 Dark theme specification.
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
      textTheme: GoogleFonts.cairoTextTheme(baseDark.textTheme),
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
}
