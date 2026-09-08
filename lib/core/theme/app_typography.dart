import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Clean typography specifications for Cairo and IBM Plex Mono.
class AppTypography {
  const AppTypography._();

  static TextStyle cairoBold({required double fontSize, Color? color}) {
    return TextStyle(
      fontFamily: 'Cairo',
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.textPrimary,
      fontFamilyFallback: const ['sans-serif', 'Roboto', 'Arial'],
    );
  }

  static TextStyle cairoSemiBold({required double fontSize, Color? color}) {
    return TextStyle(
      fontFamily: 'Cairo',
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.textPrimary,
      fontFamilyFallback: const ['sans-serif', 'Roboto', 'Arial'],
    );
  }

  static TextStyle cairoRegular({required double fontSize, Color? color}) {
    return TextStyle(
      fontFamily: 'Cairo',
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      color: color ?? AppColors.textSecondary,
      fontFamilyFallback: const ['sans-serif', 'Roboto', 'Arial'],
    );
  }

  static TextStyle monoBold({required double fontSize, Color? color}) {
    return TextStyle(
      fontFamily: 'IBM Plex Mono',
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.cyan,
      fontFamilyFallback: const ['monospace', 'Courier New'],
    );
  }

  static TextStyle monoSemiBold({required double fontSize, Color? color}) {
    return TextStyle(
      fontFamily: 'IBM Plex Mono',
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.cyan,
      fontFamilyFallback: const ['monospace', 'Courier New'],
    );
  }

  static TextStyle monoRegular({required double fontSize, Color? color}) {
    return TextStyle(
      fontFamily: 'IBM Plex Mono',
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      color: color ?? AppColors.textSecondary,
      fontFamilyFallback: const ['monospace', 'Courier New'],
    );
  }
}
