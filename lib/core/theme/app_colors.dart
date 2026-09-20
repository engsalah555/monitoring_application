import 'package:flutter/material.dart';
import 'app_palette.dart';
export 'app_palette.dart';

/// Centralized Executive Palette for AEGIS Command Center.
/// Delegates to and exposes [AppPalette] for clean design tokens.
class AppColors {
  const AppColors._();

  // ── 👑 Royal Palette Accessors (استدعاء مباشر للألوان الملكية) ────────────
  static const Color royalPrimary = AppPalette.primary;
  static const Color royalGold = AppPalette.imperialGold;
  static const Color royalNavy = AppPalette.bgDarkObsidian;
  static const Color royalObsidian = AppPalette.bgDarkObsidian;


  // ── Obsidian Surfaces (IMG_8105) ──────────────────────────────────────────
  static const Color clayBg = AppPalette.bgDarkObsidian;
  static const Color clayCard = AppPalette.cardDark;
  static const Color darkIndigo = AppPalette.surfaceDark;
  static const Color darkIndigoSurface = AppPalette.cardElevatedDark;

  // ── Executive Palette (mapped to IMG_8105) ──────────────────────────────
  static const Color executiveDarkBg = AppPalette.bgDarkObsidian;
  static const Color executiveCardDark = AppPalette.cardDark;
  static const Color executiveCardBorder = AppPalette.borderDark;
  static const Color executiveAccent = AppPalette.cyanLight;

  // ── Accents & Gradients ──────────────────────────────────────────────────
  static const Color primaryBlue = AppPalette.primary;       // Electric Violet
  static const Color primaryViolet = AppPalette.royalViolet;
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4F63F6), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient executiveGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient emergencyGradient = LinearGradient(
    colors: [Color(0xFFDC2626), Color(0xFF991B1B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0xCCFFFFFF), Color(0x99F1F5F9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient darkGlassGradient = LinearGradient(
    colors: [Color(0xEE1E293B), Color(0xCC0F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Text Hierarchy (Mapped to high-contrast light tokens for Obsidian dark theme)
  static const Color textDarkPrimary = AppPalette.textLightPrimary;
  static const Color textDarkSecondary = AppPalette.textLightSecondary;
  static const Color textDarkTertiary = AppPalette.textLightMuted;
  static const Color textLightPrimary = AppPalette.textLightPrimary;
  static const Color textLightSecondary = AppPalette.textLightSecondary;

  // ── Status Indicators ────────────────────────────────────────────────────
  static const Color cyan = Color(0xFF06B6D4);
  static const Color cyanDim = Color(0x1F06B6D4);
  static const Color amber = Color(0xFFF59E0B);
  static const Color amberDim = Color(0x1FF59E0B);
  static const Color green = Color(0xFF10B981);
  static const Color greenDim = Color(0x1F10B981);
  static const Color red = Color(0xFFEF4444);
  static const Color redDim = Color(0x26EF4444);

  // ── Backward Compatible Aliases ──────────────────────────────────────────
  static const Color bgVoid = AppPalette.bgDarkObsidian;
  static const Color bgPage = AppPalette.bgDarkObsidian;
  static const Color panel = AppPalette.cardDark;
  static const Color panelRaised = AppPalette.cardElevatedDark;
  static const Color panelLine = AppPalette.borderDark;
  static const Color steel = AppPalette.textLightMuted;
  static const Color textPrimary = AppPalette.textLightPrimary;
  static const Color textSecondary = AppPalette.textLightSecondary;
  static const Color textTertiary = AppPalette.textLightMuted;

  /// Returns active primary color depending on [isEmergency] state.
  static Color getPrimary(bool isEmergency) => isEmergency ? red : AppPalette.primary;

  /// Returns active dim primary color depending on [isEmergency] state.
  static Color getPrimaryDim(bool isEmergency) => isEmergency ? redDim : cyanDim;
}
