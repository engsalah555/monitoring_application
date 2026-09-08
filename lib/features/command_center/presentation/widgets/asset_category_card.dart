import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/royal/royal_glass.dart';
import '../../../surveillance_system/domain/entities/asset_category.dart';

/// Reusable Royal Asset Category Distribution Card.
class AssetCategoryCard extends StatelessWidget {
  final AssetCategory category;
  final IconData icon;
  final Color primaryColor;
  final VoidCallback onTap;

  const AssetCategoryCard({
    super.key,
    required this.category,
    required this.icon,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RoyalGlassContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      borderRadius: 20,
      backgroundColor: AppPalette.surfaceDark.withValues(alpha: 0.8),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.08),
        width: 1,
      ),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppPalette.royalSapphireGradient,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppPalette.primary.withValues(alpha: 0.4),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppPalette.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.title,
                  style: AppTypography.cairoBold(
                    fontSize: 14.5,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  category.subtitle,
                  style: AppTypography.cairoRegular(
                    fontSize: 11.5,
                    color: AppPalette.textLightMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppPalette.cardDark.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: AppPalette.cyanLight,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
