import 'package:flutter/material.dart';

class AppColors {
  static const Color bgVoid = Color(0xFF06090F);
  static const Color bgPage = Color(0xFF030406);
  static const Color panel = Color(0xFF0D131F);
  static const Color panelRaised = Color(0xFF141D2E);
  static const Color panelLine = Color(0xFF1F2B3E);
  static const Color steel = Color(0xFF2E3E54);

  static const Color textPrimary = Color(0xFFF0F4F8);
  static const Color textSecondary = Color(0xFF9AB0C5);
  static const Color textTertiary = Color(0xFF5C728A);

  static const Color cyan = Color(0xFF4FD1E8);
  static const Color cyanDim = Color(0x1F4FD1E8); // 12% opacity

  static const Color amber = Color(0xFFFFA83D);
  static const Color amberDim = Color(0x1FFFA83D);

  static const Color green = Color(0xFF4ADE80);

  static const Color red = Color(0xFFFF5A5F);
  static const Color redDim = Color(0x26FF5A5F); // 15% opacity

  // Helper for dynamic primary color depending on emergency mode
  static Color getPrimary(bool isEmergency) => isEmergency ? red : cyan;
  static Color getPrimaryDim(bool isEmergency) => isEmergency ? redDim : cyanDim;
}
