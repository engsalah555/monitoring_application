import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/layout/executive_list_tile.dart';
import '../../../surveillance_system/domain/entities/asset_category.dart';

/// Standardized Asset Category Distribution Card built on ExecutiveListTile.
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
    return ExecutiveListTile(
      title: category.title,
      subtitle: category.subtitle,
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          gradient: AppPalette.royalSapphireGradient,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppPalette.primary.withValues(alpha: 0.4),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppPalette.primary.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppPalette.surfaceDark,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: const Icon(
          Icons.chevron_left_rounded,
          color: AppPalette.cyanLight,
          size: 18,
        ),
      ),
    );
  }
}
