import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';
import '../widgets/camera_grid_tile.dart';

/// Screen 4: Multi view camera grid screen (4 vs 8 grid modes).
class MultiViewGridScreen extends StatelessWidget {
  const MultiViewGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AegisProvider>();
    final primaryColor = AppColors.getPrimary(provider.isEmergency);
    final isFourGrid = provider.gridCount == 4;

    return Column(
      children: [
        // Multi view Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.multiStreamTitle,
                style: AppTypography.cairoBold(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              // Layout segment selector
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.panel,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.panelLine),
                ),
                child: Row(
                  children: [
                    _buildGridButton(
                      count: 4,
                      label: AppStrings.grid4Cam,
                      isSelected: isFourGrid,
                      primaryColor: primaryColor,
                      onTap: () => provider.setGridCount(4),
                    ),
                    _buildGridButton(
                      count: 8,
                      label: AppStrings.grid8Cam,
                      isSelected: !isFourGrid,
                      primaryColor: primaryColor,
                      onTap: () => provider.setGridCount(8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Camera Grid View
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: isFourGrid ? 1.2 : 1.5,
              children: [
                const CameraGridTile(camName: 'كاميرا ١٤', isLive: true),
                const CameraGridTile(camName: 'كاميرا ١٥', isLive: true),
                const CameraGridTile(camName: 'كاميرا ١٦', isOffline: true),
                const CameraGridTile(camName: 'كاميرا ١٧', isAlert: true),
                if (!isFourGrid) ...[
                  const CameraGridTile(camName: 'كاميرا ١٨', isLive: true),
                  const CameraGridTile(camName: 'كاميرا ١٩', isLive: true),
                  const CameraGridTile(camName: 'كاميرا ٢٠', isLive: true),
                  const CameraGridTile(camName: 'كاميرا ٢١', isLive: true),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridButton({
    required int count,
    required String label,
    required bool isSelected,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.panelRaised : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: AppTypography.cairoBold(
            fontSize: 11,
            color: isSelected ? primaryColor : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
