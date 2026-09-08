import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

import '../../../../core/theme/neumorphic_decorations.dart';

/// Reusable Section Group Card Widget for Settings Screen.
class SettingsSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const SettingsSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: NeumorphicDecorations.softRaised(
        color: AppColors.clayCard,
        borderRadius: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: AppTypography.cairoBold(
                    fontSize: 14,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          ...children,
        ],
      ),
    );
  }
}
