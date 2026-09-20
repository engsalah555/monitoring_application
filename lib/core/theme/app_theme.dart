import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_palette.dart';

/// Central Material 3 Theme — AEGIS Command Center.
///
/// Primary design system: Matte Obsidian (`#0B0B0F`) + Electric Violet
/// (`#7C5CFC`) matching IMG_8105.WEBP aesthetic.
class AppTheme {
  const AppTheme._();

  // ── Dark Theme — Matte Obsidian + Electric Violet ─────────────────────────
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppPalette.bgDarkObsidian,
      colorScheme: const ColorScheme.dark(
        primary: AppPalette.primary,
        primaryContainer: AppPalette.primaryDark,
        secondary: AppPalette.cyanLight,
        secondaryContainer: AppPalette.cyanGlow,
        surface: AppPalette.surfaceDark,
        surfaceContainerHighest: AppPalette.cardElevatedDark,
        error: AppPalette.crimsonAlert,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppPalette.textLightPrimary,
        onError: Colors.white,
        outline: AppPalette.borderDark,
        shadow: Color(0xFF000000),
      ),
      textTheme: base.textTheme.apply(
        fontFamily: 'Cairo',
        bodyColor: AppPalette.textLightPrimary,
        displayColor: AppPalette.textLightPrimary,
      ),
      iconTheme: const IconThemeData(
        color: AppPalette.textLightSecondary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppPalette.bgDarkObsidian,
        foregroundColor: AppPalette.textLightPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppPalette.bgDarkObsidian,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppPalette.primary,
        unselectedItemColor: AppPalette.dockInactiveIcon,
      ),
      cardTheme: CardThemeData(
        color: AppPalette.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppPalette.borderDark),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppPalette.borderDark,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.surfaceDark,
        hintStyle: const TextStyle(
          color: AppPalette.textLightMuted,
          fontFamily: 'Cairo',
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppPalette.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppPalette.primary, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppPalette.primary
              : AppPalette.textLightMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppPalette.primaryGlow
              : AppPalette.surfaceDark,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppPalette.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppPalette.borderDark),
        ),
      ),
    );
  }

  // ── Light Theme — kept minimal, redirects to dark for now ─────────────────
  static ThemeData get lightTheme => darkTheme;
}
