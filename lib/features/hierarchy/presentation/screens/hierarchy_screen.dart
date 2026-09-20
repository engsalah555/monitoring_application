import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/feedback/cctv_state_view.dart';
import '../../../../core/widgets/inputs/executive_segmented_control.dart';
import '../../../../core/widgets/royal/royal_button.dart';
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

  static const List<SegmentItem<int>> _hierarchySegments = [
    SegmentItem(value: 0, label: AppStrings.camListTab, icon: Icons.view_list_rounded),
    SegmentItem(value: 1, label: AppStrings.floorMapTab, icon: Icons.map_outlined),
  ];

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
              RoyalButton(
                label: 'ربط NVR',
                icon: Icons.add_rounded,
                variant: RoyalButtonVariant.primary,
                height: 42,
                borderRadius: 14,
                onPressed: () => AddBranchDialog.show(context),
              ),
            ],
          ),
        ),

        // Unified Segmented Control
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ExecutiveSegmentedControl<int>(
            items: _hierarchySegments,
            selectedValue: _segmentedIndex,
            isExpanded: true,
            onValueChanged: (val) => setState(() => _segmentedIndex = val),
          ),
        ),

        // Content Area with Empty State Handling
        Expanded(
          child: _segmentedIndex == 0
              ? (provider.zoneCameras.isEmpty
                  ? CctvStateView.emptyCameras(
                      onAddCamera: () => AddBranchDialog.show(context),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: provider.zoneCameras.length,
                      itemBuilder: (context, index) {
                        final camera = provider.zoneCameras[index];
                        return CameraRowTile(
                          camera: camera,
                          isEmergency: provider.isEmergency,
                          onTap: () => provider.setSelectedTab(AppTab.liveSingle),
                        );
                      },
                    ))
              : const FloorMapView(primaryColor: AppColors.primaryBlue),
        ),
      ],
    );
  }
}
