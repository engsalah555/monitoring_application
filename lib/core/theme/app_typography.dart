import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Clean typography specifications for Cairo and IBM Plex Mono.
class AppTypography {
  const AppTypography._();

  static TextStyle cairoBold({required double fontSize, Color? color}) {
    return GoogleFonts.cairo(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.textPrimary,
    );
  }

  static TextStyle cairoSemiBold({required double fontSize, Color? color}) {
    return GoogleFonts.cairo(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.textPrimary,
    );
  }

  static TextStyle cairoRegular({required double fontSize, Color? color}) {
    return GoogleFonts.cairo(
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      color: color ?? AppColors.textSecondary,
    );
  }

  static TextStyle monoBold({required double fontSize, Color? color}) {
    return GoogleFonts.ibmPlexMono(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.cyan,
    );
  }

  static TextStyle monoSemiBold({required double fontSize, Color? color}) {
    return GoogleFonts.ibmPlexMono(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.cyan,
    );
  }

  static TextStyle monoRegular({required double fontSize, Color? color}) {
    return GoogleFonts.ibmPlexMono(
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      color: color ?? AppColors.textSecondary,
    );
  }
}
