import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/inputs/executive_segmented_control.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';
import '../widgets/camera_grid_tile.dart';

/// Screen 4: Multi view camera grid screen (4 vs 8 grid modes) with virtualized GridView.builder.
class MultiViewGridScreen extends StatelessWidget {
  const MultiViewGridScreen({super.key});

  static const List<SegmentItem<int>> _gridSegmentItems = [
    SegmentItem(value: 4, label: AppStrings.grid4Cam, icon: Icons.grid_view_rounded),
    SegmentItem(value: 8, label: AppStrings.grid8Cam, icon: Icons.apps_rounded),
  ];

  static const List<({String name, bool isLive, bool isOffline, bool isAlert})> _mockStreams = [
    (name: 'كاميرا ١٤ • المدخل', isLive: true, isOffline: false, isAlert: false),
    (name: 'كاميرا ١٥ • المواقف', isLive: true, isOffline: false, isAlert: false),
    (name: 'كاميرا ١٦ • المستودع', isLive: false, isOffline: true, isAlert: false),
    (name: 'كاميرا ١٧ • الطوارئ', isLive: false, isOffline: false, isAlert: true),
    (name: 'كاميرا ١٨ • البوابة ٢', isLive: true, isOffline: false, isAlert: false),
    (name: 'كاميرا ١٩ • الرصيف', isLive: true, isOffline: false, isAlert: false),
    (name: 'كاميرا ٢٠ • السور', isLive: true, isOffline: false, isAlert: false),
    (name: 'كاميرا ٢١ • المكاتب', isLive: true, isOffline: false, isAlert: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Selector<AegisProvider, ({int gridCount, bool isEmergency})>(
      selector: (_, p) => (gridCount: p.gridCount, isEmergency: p.isEmergency),
      builder: (context, state, child) {
        final provider = context.read<AegisProvider>();
        final primaryColor = AppColors.getPrimary(state.isEmergency);
        final isFourGrid = state.gridCount == 4;
        final displayCount = isFourGrid ? 4 : 8;

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
                  ExecutiveSegmentedControl<int>(
                    items: _gridSegmentItems,
                    selectedValue: state.gridCount,
                    activeColor: primaryColor,
                    onValueChanged: (val) => provider.setGridCount(val),
                  ),
                ],
              ),
            ),

            // Camera Grid View (Virtualized builder)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: isFourGrid ? 1.2 : 1.5,
                  ),
                  itemCount: displayCount,
                  itemBuilder: (context, index) {
                    final item = _mockStreams[index % _mockStreams.length];
                    return CameraGridTile(
                      camName: item.name,
                      isLive: item.isLive,
                      isOffline: item.isOffline,
                      isAlert: item.isAlert,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
