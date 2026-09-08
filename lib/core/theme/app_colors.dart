import 'package:flutter/material.dart';
import 'app_palette.dart';

/// Centralized Executive Palette for AEGIS Command Center.
/// Delegates to and exposes [AppPalette] for clean design tokens.
class AppColors {
  const AppColors._();

  // ── 👑 Royal Palette Accessors (استدعاء مباشر للألوان الملكية) ────────────
  static const Color royalPrimary = AppPalette.primary;
  static const Color royalGold = AppPalette.imperialGold;
  static const Color royalNavy = AppPalette.royalNavy;
  static const Color royalObsidian = AppPalette.bgDarkObsidian;


  // ── Neumorphic Dual-Tone Core Colors ─────────────────────────────────────
  static const Color clayBg = Color(0xFFEFF2F9); // Soft lavender-grey clay background
  static const Color clayCard = Color(0xFFF7F9FE); // Elevated white-clay surface
  static const Color darkIndigo = Color(0xFF181E36); // Deep midnight indigo header section
  static const Color darkIndigoSurface = Color(0xFF222947); // Dark card container

  // ── Executive Store-Grade Modern Palette ────────────────────────────────
  static const Color executiveDarkBg = Color(0xFF0F172A); // Premium Slate 900
  static const Color executiveCardDark = Color(0xFF1E293B); // Elevated Slate 800
  static const Color executiveCardBorder = Color(0xFF334155); // Slate 700 border
  static const Color executiveAccent = Color(0xFF38BDF8); // Sky blue neon accent

  // ── Accents & Gradients ──────────────────────────────────────────────────
  static const Color primaryBlue = Color(0xFF4F63F6); // Soft royal indigo blue
  static const Color primaryViolet = Color(0xFF8B5CF6); // Soft violet accent
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

  // ── Text Hierarchy ───────────────────────────────────────────────────────
  static const Color textDarkPrimary = Color(0xFF1E293B); // Slate 800
  static const Color textDarkSecondary = Color(0xFF64748B); // Slate 500
  static const Color textDarkTertiary = Color(0xFF94A3B8); // Slate 400
  static const Color textLightPrimary = Color(0xFFF8FAFC);
  static const Color textLightSecondary = Color(0xFFCBD5E1);

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
  static const Color bgVoid = clayBg;
  static const Color bgPage = clayBg;
  static const Color panel = clayCard;
  static const Color panelRaised = clayCard;
  static const Color panelLine = Color(0xFFE2E8F0);
  static const Color steel = Color(0xFFCBD5E1);
  static const Color textPrimary = textDarkPrimary;
  static const Color textSecondary = textDarkSecondary;
  static const Color textTertiary = textDarkTertiary;

  /// Returns active primary color depending on [isEmergency] state.
  static Color getPrimary(bool isEmergency) => isEmergency ? red : primaryBlue;

  /// Returns active dim primary color depending on [isEmergency] state.
  static Color getPrimaryDim(bool isEmergency) => isEmergency ? redDim : cyanDim;
}
