import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../surveillance_system/domain/entities/asset_category.dart';

import '../../../../core/theme/neumorphic_decorations.dart';

/// Reusable Asset Category Distribution Card.
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
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: NeumorphicDecorations.softRaised(
        color: AppColors.clayCard,
        borderRadius: 22,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withValues(alpha: 0.3),
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
                          fontSize: 14,
                          color: AppColors.textDarkPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        category.subtitle,
                        style: AppTypography.cairoRegular(
                          fontSize: 11,
                          color: AppColors.textDarkSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primaryBlue,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
