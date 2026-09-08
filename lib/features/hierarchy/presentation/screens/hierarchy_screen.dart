import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../surveillance_system/domain/entities/app_tab.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';
import '../widgets/add_branch_dialog.dart';
import '../widgets/camera_row_tile.dart';
import '../widgets/floor_map_view.dart';
import '../widgets/hierarchy_breadcrumb.dart';

import '../../../../core/theme/neumorphic_decorations.dart';

/// Screen 2: Hierarchy and Asset locations list screen.
class HierarchyScreen extends StatefulWidget {
  const HierarchyScreen({super.key});

  @override
  State<HierarchyScreen> createState() => _HierarchyScreenState();
}

class _HierarchyScreenState extends State<HierarchyScreen> {
  int _segmentedIndex = 0; // 0: Cam List, 1: Floor Map

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AegisProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HierarchyBreadcrumb(primaryColor: AppColors.primaryBlue),

        // Section Title Header with Add Branch Button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.zoneTitle,
                    style: AppTypography.cairoBold(
                      fontSize: 16.5,
                      color: AppColors.textDarkPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppStrings.zoneSubtitle,
                    style: AppTypography.cairoRegular(
                      fontSize: 12,
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => AddBranchDialog.show(context),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
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
                      const Icon(Icons.add_rounded,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'ربط NVR',
                        style: AppTypography.cairoBold(
                            fontSize: 11.5, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Neumorphic Segmented Control
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(4),
          decoration: NeumorphicDecorations.softRaised(
            color: AppColors.clayCard,
            borderRadius: 18,
          ),
          child: Row(
            children: [
              _buildSegmentTab(
                index: 0,
                label: AppStrings.camListTab,
              ),
              _buildSegmentTab(
                index: 1,
                label: AppStrings.floorMapTab,
              ),
            ],
          ),
        ),

        // Content Area
        Expanded(
          child: _segmentedIndex == 0
              ? ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: provider.zoneCameras.length,
                  itemBuilder: (context, index) {
                    final camera = provider.zoneCameras[index];
                    return CameraRowTile(
                      camera: camera,
                      isEmergency: provider.isEmergency,
                      onTap: () => provider.setSelectedTab(AppTab.liveSingle),
                    );
                  },
                )
              : const FloorMapView(primaryColor: AppColors.primaryBlue),
        ),
      ],
    );
  }

  Widget _buildSegmentTab({
    required int index,
    required String label,
  }) {
    final isSelected = _segmentedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _segmentedIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: isSelected
              ? BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                )
              : null,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.cairoBold(
              fontSize: 11.5,
              color: isSelected ? Colors.white : AppColors.textDarkSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
