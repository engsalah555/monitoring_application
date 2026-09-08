import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/royal/royal_kit.dart';
import '../../../surveillance_system/domain/entities/app_tab.dart';
import '../../../surveillance_system/domain/entities/camera_status.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';
import '../../../surveillance_system/presentation/widgets/add_device_wizard_dialog.dart';
import '../widgets/asset_category_card.dart';
import '../widgets/executive_header_card.dart';
import '../widgets/favorite_camera_item.dart';
import '../widgets/kpi_metrics_strip.dart';

/// Screen 1: Command Center executive dashboard.
class CommandCenterScreen extends StatelessWidget {
  const CommandCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AegisProvider>();
    final isEmergency = provider.isEmergency;
    final primaryAccent =
        isEmergency ? AppPalette.crimsonAlert : AppPalette.cyanLight;

    final icons = [
      Icons.store_mall_directory_outlined,
      Icons.inventory_2_outlined,
      Icons.people_outline,
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ExecutiveHeaderCard(),
          const SizedBox(height: 14),

          const KpiMetricsStrip(),
          const SizedBox(height: 14),

          // Executive Action Chip & Search Field Row (Royal UI Kit)
          Row(
            children: [
              Expanded(
                child: RoyalGlassContainer(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  borderRadius: 16,
                  backgroundColor: AppPalette.surfaceDark.withValues(alpha: 0.7),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        color: AppPalette.cyanLight,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppStrings.searchPlaceholder,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.cairoRegular(
                            fontSize: 12,
                            color: AppPalette.textLightMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              RoyalButton(
                label: 'ربط موقع جديد',
                icon: Icons.add_business_rounded,
                variant: RoyalButtonVariant.primary,
                height: 48,
                borderRadius: 16,
                onPressed: () => AddDeviceWizardDialog.show(context),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // Section 1: Favorites & Critical Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: primaryAccent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.criticalAndFavorites,
                    style: AppTypography.cairoBold(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Text(
                    AppStrings.editFavorites,
                    style: AppTypography.cairoBold(
                      fontSize: 11.5,
                      color: primaryAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: provider.favoriteCameras.map((cam) {
                final color = cam.status == CameraStatus.alert
                    ? (isEmergency
                        ? AppPalette.crimsonAlert
                        : AppPalette.amberWarning)
                    : primaryAccent;
                final isAlert = cam.status == CameraStatus.alert;

                return Padding(
                  padding: const EdgeInsets.only(left: 12),
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
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppPalette.imperialGold,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.assetsDistribution,
                    style: AppTypography.cairoBold(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                AppStrings.totalCamerasCount,
                style: AppTypography.cairoBold(
                  fontSize: 11.5,
                  color: AppPalette.imperialGold,
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
              primaryColor: primaryAccent,
              onTap: () => provider.setSelectedTab(AppTab.hierarchy),
            );
          }),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
