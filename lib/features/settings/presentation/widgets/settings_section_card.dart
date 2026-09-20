import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';

/// Reusable Section Group Card Widget for Settings Screen with Matte Obsidian styling.
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppPalette.borderDark),
        boxShadow: AppPalette.softCardShadow,
      ),
      child: Material(
        color: AppPalette.cardDark,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
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
                    gradient: AppPalette.royalSapphireGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: AppTypography.cairoBold(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppPalette.borderDark),
          ...children,
        ],
      ),
    ),
  );
}
}
