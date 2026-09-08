import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/neumorphic_decorations.dart';
import '../../../surveillance_system/domain/entities/app_tab.dart';
import '../../../surveillance_system/domain/entities/camera_status.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';
import '../widgets/asset_category_card.dart';
import '../widgets/executive_header_card.dart';
import '../widgets/favorite_camera_item.dart';
import '../widgets/kpi_metrics_strip.dart';

import '../../../surveillance_system/presentation/widgets/add_device_wizard_dialog.dart';

/// Screen 1: Command Center executive dashboard.
class CommandCenterScreen extends StatelessWidget {
  const CommandCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AegisProvider>();
    final primaryColor = AppColors.getPrimary(provider.isEmergency);

    final icons = [
      Icons.store_mall_directory_outlined,
      Icons.inventory_2_outlined,
      Icons.people_outline,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ExecutiveHeaderCard(),
          const SizedBox(height: 16),

          const KpiMetricsStrip(),
          const SizedBox(height: 16),

          // Executive Action Chip & Search Field Row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: NeumorphicDecorations.softRaised(
                    color: AppColors.clayCard,
                    borderRadius: 16,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded,
                          color: AppColors.primaryBlue, size: 20),
                      Expanded(
                        child: Text(
                          AppStrings.searchPlaceholder,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.cairoRegular(
                            fontSize: 12,
                            color: AppColors.textDarkTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => AddDeviceWizardDialog.show(context),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.add_business_rounded,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'ربط كاميرات / موقع جديد',
                        style: AppTypography.cairoBold(
                            fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // Section 1: Favorites & Critical Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.criticalAndFavorites,
                style: AppTypography.cairoBold(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                AppStrings.editFavorites,
                style: AppTypography.cairoBold(
                  fontSize: 11,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: provider.favoriteCameras.map((cam) {
                final color = cam.status == CameraStatus.alert
                    ? (provider.isEmergency ? AppColors.red : AppColors.amber)
                    : primaryColor;
                final isAlert = cam.status == CameraStatus.alert;

                return Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: FavoriteCameraItem(
                    label: cam.name,
                    color: color,
                    isAlert: isAlert,
                    onTap: () => provider.setSelectedTab(AppTab.liveSingle),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Section 2: Distributed Assets
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.assetsDistribution,
                style: AppTypography.cairoBold(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                AppStrings.totalCamerasCount,
                style: AppTypography.cairoBold(
                  fontSize: 11,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...List.generate(provider.assetCategories.length, (index) {
            final category = provider.assetCategories[index];
            return AssetCategoryCard(
              category: category,
              icon: icons[index % icons.length],
              primaryColor: primaryColor,
              onTap: () => provider.setSelectedTab(AppTab.hierarchy),
            );
          }),
        ],
      ),
    );
  }
}
