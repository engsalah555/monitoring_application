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
    final primaryColor = AppColors.getPrimary(provider.isEmergency);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HierarchyBreadcrumb(primaryColor: primaryColor),

        // Section Title Header with Add Branch Button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.panelLine)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.zoneTitle,
                    style: AppTypography.cairoBold(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppStrings.zoneSubtitle,
                    style: AppTypography.cairoRegular(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.panelRaised,
                  side: BorderSide(color: primaryColor),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                icon: Icon(Icons.add, color: primaryColor, size: 16),
                label: Text(
                  'ربط NVR',
                  style: AppTypography.cairoBold(fontSize: 11, color: primaryColor),
                ),
                onPressed: () => AddBranchDialog.show(context),
              ),
            ],
          ),
        ),

        // Segmented Control
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppColors.panel,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.panelLine),
          ),
          child: Row(
            children: [
              _buildSegmentTab(
                index: 0,
                label: AppStrings.camListTab,
                primaryColor: primaryColor,
              ),
              _buildSegmentTab(
                index: 1,
                label: AppStrings.floorMapTab,
                primaryColor: primaryColor,
              ),
            ],
          ),
        ),

        // Content Area
        Expanded(
          child: _segmentedIndex == 0
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
              : FloorMapView(primaryColor: primaryColor),
        ),
      ],
    );
  }

  Widget _buildSegmentTab({
    required int index,
    required String label,
    required Color primaryColor,
  }) {
    final isSelected = _segmentedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _segmentedIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.panelRaised : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.cairoBold(
              fontSize: 11,
              color: isSelected ? primaryColor : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
