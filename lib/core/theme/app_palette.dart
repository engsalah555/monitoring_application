import 'package:flutter/material.dart';

/// Centralized Design System Palette for AEGIS Command Center.
///
/// Encapsulates the Royal Luxury palette: Deep Obsidian & Royal Sapphire
/// with Imperial Champagne Gold & Luminous Cyan accents.
class AppPalette {
  const AppPalette._();

  // ── 👑 Primary Brand Colors (الألوان الرئيسية الملكية) ──────────────────
  /// Royal Sapphire Primary - represents trust, stability, and intelligence.
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color royalNavy = Color(0xFF0F172A); // Deep Obsidian Slate
  static const Color royalCobalt = Color(0xFF1E3A8A); // Deep Royal Blue

  // ── 🌟 Secondary & Luxury Accent Colors (الألوان الثانوية واللمسات الفاخرة) ──
  /// Imperial Champagne Gold - conveys luxury, executive authority, and prestige.
  static const Color imperialGold = Color(0xFFD4AF37);
  static const Color champagneGold = Color(0xFFF5E6BE);
  static const Color goldGlow = Color(0x33D4AF37);

  /// Luminous Cyan & Radiant Violet - for high-tech surveillance telemetry.
  static const Color cyan = Color(0xFF06B6D4);
  static const Color cyanLight = Color(0xFF38BDF8);
  static const Color cyanGlow = Color(0x2E06B6D4);
  static const Color royalViolet = Color(0xFF8B5CF6);
  static const Color violetGlow = Color(0x2E8B5CF6);

  // ── 🌑 Luxury Dark Surfaces (أسطح الوضع الملكي الداكن) ─────────────────────
  static const Color bgDarkObsidian = Color(0xFF0A0F1D); // Pure deep dark midnight
  static const Color surfaceDark = Color(0xFF131B2E); // Deep indigo-slate
  static const Color cardDark = Color(0xFF1A243B); // Elevated royal card surface
  static const Color cardElevatedDark = Color(0xFF23304E); // Highlighted surface
  static const Color borderDark = Color(0x2994A3B8); // Subtle hairline slate border
  static const Color borderGlow = Color(0x4038BDF8); // Cyan ambient border glow
  static const Color borderGold = Color(0x40D4AF37); // Subtle gold hairline border

  // ── ☀️ Royal Porcelain Light Surfaces (أسطح الوضع الملكي الفاتح) ───────────
  static const Color bgLightPorcelain = Color(0xFFF4F6FB); // Soft regal porcelain
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure elevated card surface
  static const Color cardLight = Color(0xFFF9FAFD); // Soft tinted card
  static const Color borderLight = Color(0xFFE2E8F0); // Delicate border

  // ── 🚦 Semantic Status Indicators (ألوان الحالات التشغيلية) ───────────────
  /// Emerald Green: Camera Online, All Systems Operational
  static const Color emeraldLive = Color(0xFF10B981);
  static const Color emeraldGlow = Color(0x3310B981);

  /// Amber Gold: Warning, Motion Detected, Storage Notice
  static const Color amberWarning = Color(0xFFF59E0B);
  static const Color amberGlow = Color(0x33F59E0B);

  /// Crimson Red: Critical Threat, Alarm Triggered, Emergency Lockdown
  static const Color crimsonAlert = Color(0xFFEF4444);
  static const Color crimsonGlow = Color(0x3DEF4444);

  // ── ✍️ Text Hierarchy (ألوان النصوص الملكية) ──────────────────────────────
  static const Color textLightPrimary = Color(0xFFFFFFFF);
  static const Color textLightSecondary = Color(0xFFCBD5E1);
  static const Color textLightMuted = Color(0xFF94A3B8);

  static const Color textDarkPrimary = Color(0xFF0F172A);
  static const Color textDarkSecondary = Color(0xFF475569);
  static const Color textDarkMuted = Color(0xFF64748B);

  // ── 🌌 Luxury Gradients (التدرجات الملكية الفاخرة) ─────────────────────────
  static const LinearGradient royalSapphireGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient imperialGoldGradient = LinearGradient(
    colors: [Color(0xFFF5E6BE), Color(0xFFD4AF37), Color(0xFFAA8010)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassOverlayGradient = LinearGradient(
    colors: [Color(0x33FFFFFF), Color(0x0DFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGlassGradient = LinearGradient(
    colors: [Color(0xE61E293B), Color(0xCC0F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emergencyGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFF991B1B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── 🔮 Luxury Soft Ambient Shadows (الظلال المخملية الناعمة) ─────────────
  static List<BoxShadow> get royalShadow => [
        BoxShadow(
          color: primary.withValues(alpha: 0.22),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get floatingDockShadow => [
        const BoxShadow(
          color: Color(0x40000000),
          blurRadius: 24,
          spreadRadius: 2,
          offset: Offset(0, 10),
        ),
        BoxShadow(
          color: primary.withValues(alpha: 0.15),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get softCardShadow => [
        const BoxShadow(
          color: Color(0x14000000),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ];
}
