import 'package:flutter/material.dart';

/// Centralized Design System Palette — AEGIS Command Center.
///
/// Palette source: IMG_8105.WEBP — Matte Obsidian Dark with Electric Violet
/// accents, Cyan telemetry highlights, and Coral alert indicators.
/// Floating Capsule Dock with White-Pill active state.
class AppPalette {
  const AppPalette._();

  // ── 🎨 Primary Brand — Electric Violet (IMG_8105 Signature) ──────────────
  static const Color primary = Color(0xFF7C5CFC);
  static const Color primaryLight = Color(0xFF9B80FF);
  static const Color primaryDark = Color(0xFF5B3DD8);
  static const Color primaryGlow = Color(0x407C5CFC);

  // backward-compat alias kept for screens that still reference camGuardBlue
  static const Color camGuardBlue = Color(0xFF7C5CFC);

  // ── 🔵 Secondary Accents ─────────────────────────────────────────────────
  /// Cyan — telemetry curves, storage indicators, stream quality.
  static const Color cyan = Color(0xFF06B6D4);
  static const Color cyanLight = Color(0xFF38BDF8);
  static const Color cyanGlow = Color(0x3038BDF8);

  /// Coral / Rose — lower-limit curves, critical badges.
  static const Color coral = Color(0xFFFB7185);
  static const Color coralGlow = Color(0x30FB7185);

  /// Imperial Gold — prestige badges, section separators.
  static const Color imperialGold = Color(0xFFD4AF37);
  static const Color champagneGold = Color(0xFFF5E6BE);
  static const Color goldGlow = Color(0x33D4AF37);

  /// Violet secondary shades.
  static const Color royalViolet = Color(0xFF8B5CF6);
  static const Color violetGlow = Color(0x308B5CF6);

  // ── 🌑 Matte Obsidian Surfaces (IMG_8105 exact tones) ────────────────────
  /// Background — deepest matte obsidian.
  static const Color bgDarkObsidian = Color(0xFF0B0B0F);

  /// Container surfaces.
  static const Color surfaceDark = Color(0xFF16161F);
  static const Color cardDark = Color(0xFF1A1A26);
  static const Color cardElevatedDark = Color(0xFF222232);

  // Floating Dock pill colours.
  static const Color dockBackground = Color(0xFF16161F);
  static const Color dockActivePill = Color(0xFFFFFFFF); // White active capsule
  static const Color dockActiveIcon = Color(0xFF0B0B0F); // Black icon on white
  static const Color dockInactiveIcon = Color(0xFF6B7080); // Muted grey

  // Borders.
  static const Color borderDark = Color(0x1AFFFFFF);
  static const Color borderGlow = Color(0x407C5CFC);
  static const Color borderGold = Color(0x40D4AF37);

  // ── ☀️ Light Surfaces ────────────────────────────────────────────────────
  static const Color bgLightPorcelain = Color(0xFFF4F6FB);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFF9FAFD);
  static const Color borderLight = Color(0xFFE2E8F0);

  // ── 🚦 Semantic Status ───────────────────────────────────────────────────
  static const Color emeraldLive = Color(0xFF10B981);
  static const Color emeraldGlow = Color(0x3310B981);
  static const Color amberWarning = Color(0xFFF59E0B);
  static const Color amberGlow = Color(0x33F59E0B);
  static const Color crimsonAlert = Color(0xFFEF4444);
  static const Color crimsonGlow = Color(0x3DEF4444);

  // ── ✍️ Text Hierarchy ────────────────────────────────────────────────────
  static const Color textLightPrimary = Color(0xFFFFFFFF);
  static const Color textLightSecondary = Color(0xFFB0B8CC);
  static const Color textLightMuted = Color(0xFF6B7280);

  static const Color textDarkPrimary = Color(0xFF0F172A);
  static const Color textDarkSecondary = Color(0xFF475569);
  static const Color textDarkMuted = Color(0xFF64748B);

  // ── 🌌 Gradients ─────────────────────────────────────────────────────────

  /// Signature violet gradient — primary CTAs, command orb, hero cards.
  static const LinearGradient violetGradient = LinearGradient(
    colors: [Color(0xFF7C5CFC), Color(0xFF5B3DD8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Alias so older code using camGuardGradient still compiles.
  static const LinearGradient camGuardGradient = violetGradient;

  /// Royal Sapphire — kept for command orb fallback.
  static const LinearGradient royalSapphireGradient = LinearGradient(
    colors: [Color(0xFF7C5CFC), Color(0xFF4F46E5), Color(0xFF38BDF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark glass — frosted overlays inside video views.
  static const LinearGradient darkGlassGradient = LinearGradient(
    colors: [Color(0xE61E1E2C), Color(0xCC0B0B0F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Violet histogram bar — for neon waveform bars in IMG_8105 card.
  static const LinearGradient histogramBarGradient = LinearGradient(
    colors: [Color(0xFF7C5CFC), Color(0xFF9B80FF)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  /// Dimmed histogram bar — less-active bars.
  static const LinearGradient histogramBarDimGradient = LinearGradient(
    colors: [Color(0xFF3A2E6E), Color(0xFF4D3E8C)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
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

  static const LinearGradient emergencyGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFF991B1B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── 🔮 Shadows ────────────────────────────────────────────────────────────
  static List<BoxShadow> get royalShadow => [
        BoxShadow(
          color: primary.withValues(alpha: 0.28),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  /// Shadow for the IMG_8105-style floating capsule dock.
  static List<BoxShadow> get floatingDockShadow => [
        const BoxShadow(
          color: Color(0x60000000),
          blurRadius: 28,
          spreadRadius: 0,
          offset: Offset(0, 12),
        ),
        BoxShadow(
          color: primary.withValues(alpha: 0.18),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get softCardShadow => [
        const BoxShadow(
          color: Color(0x18000000),
          blurRadius: 14,
          offset: Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get violetCardShadow => [
        BoxShadow(
          color: primary.withValues(alpha: 0.22),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];
}
