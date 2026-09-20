import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/feedback/cctv_state_view.dart';
import '../../../../core/widgets/inputs/executive_segmented_control.dart';
import '../../../../core/widgets/royal/royal_kit.dart';
import '../../../surveillance_system/domain/entities/app_tab.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';
import '../../../surveillance_system/presentation/widgets/add_device_wizard_dialog.dart';
import '../widgets/asset_category_card.dart';
import '../widgets/executive_header_card.dart';
import '../widgets/histogram_activity_card.dart';
import '../widgets/kpi_metrics_strip.dart';
import '../widgets/live_camera_stream_card.dart';

/// Screen 1 — Command Center Executive Dashboard.
///
/// Visual system: Matte Obsidian (`#0B0B0F`) + Electric Violet (`#7C5CFC`)
/// matching IMG_8105.WEBP. Integrates the animated Histogram Activity Card
/// and the updated Zone Filter Chips with violet active state.
class CommandCenterScreen extends StatefulWidget {
  const CommandCenterScreen({super.key});

  @override
  State<CommandCenterScreen> createState() => _CommandCenterScreenState();
}

class _CommandCenterScreenState extends State<CommandCenterScreen> {
  int _selectedFilterIndex = 0;

  static const List<SegmentItem<int>> _zoneSegmentItems = [
    SegmentItem(value: 0, label: 'الكل', icon: Icons.grid_view_rounded),
    SegmentItem(value: 1, label: 'المستودعات', icon: Icons.inventory_2_outlined),
    SegmentItem(value: 2, label: 'المدخل', icon: Icons.door_front_door_outlined),
    SegmentItem(value: 3, label: 'الاستقبال', icon: Icons.desk_outlined),
    SegmentItem(value: 4, label: 'المواقف', icon: Icons.local_parking_rounded),
  ];

  static const List<String> _zoneFilters = [
    'الكل',
    'المستودعات',
    'المدخل',
    'الاستقبال',
    'المواقف',
  ];

  static const List<IconData> _categoryIcons = [
    Icons.store_mall_directory_outlined,
    Icons.inventory_2_outlined,
    Icons.people_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return Selector<AegisProvider, ({bool isEmergency, List cameras, List categories})>(
      selector: (_, p) => (
        isEmergency: p.isEmergency,
        cameras: p.favoriteCameras,
        categories: p.assetCategories,
      ),
      builder: (context, data, _) {
        final provider = context.read<AegisProvider>();
        final primaryAccent =
            data.isEmergency ? AppPalette.crimsonAlert : AppPalette.primary;

        final filteredCameras = data.cameras.where((cam) {
          if (_selectedFilterIndex == 0) return true;
          final tag = _zoneFilters[_selectedFilterIndex];
          return cam.name.contains(tag) || cam.location.contains(tag);
        }).toList();

        final displayCameras =
            filteredCameras.isEmpty ? data.cameras : filteredCameras;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Executive Header ────────────────────────────────────────
              const ExecutiveHeaderCard(),
              const SizedBox(height: 14),

              // ── KPI Strip ───────────────────────────────────────────────
              const KpiMetricsStrip(),
              const SizedBox(height: 16),

              // ── Histogram Activity Card (IMG_8105 signature widget) ─────
              const HistogramActivityCard(),
              const SizedBox(height: 20),

              // ── Search + Add Row ────────────────────────────────────────
              _buildSearchAddRow(context),
              const SizedBox(height: 20),

              // ── Section: Live Feeds ─────────────────────────────────────
              _SectionHeader(
                title: 'شاشات البث المباشر والتنبيهات',
                accentColor: primaryAccent,
                trailing: _MultiViewButton(provider: provider),
              ),
              const SizedBox(height: 12),

              // ── Zone Filter Chips ───────────────────────────────────────
              ExecutiveSegmentedControl<int>(
                items: _zoneSegmentItems,
                selectedValue: _selectedFilterIndex,
                onValueChanged: (val) {
                  setState(() => _selectedFilterIndex = val);
                },
              ),
              const SizedBox(height: 14),

              // ── Camera Feed Cards (Virtualized Horizontal Feed) ─────────
              if (displayCameras.isEmpty)
                CctvStateView.emptyCameras(
                  onAddCamera: () => AddDeviceWizardDialog.show(context),
                )
              else
                SizedBox(
                  height: 175,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: displayCameras.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final cam = displayCameras[index];
                      return LiveCameraStreamCard(
                        camera: cam,
                        isEmergency: data.isEmergency,
                        onTap: () => provider.setSelectedTab(AppTab.liveSingle),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 24),

              // ── Section: Assets ─────────────────────────────────────────
              _SectionHeader(
                title: AppStrings.assetsDistribution,
                accentColor: AppPalette.imperialGold,
                trailing: Text(
                  AppStrings.totalCamerasCount,
                  style: AppTypography.cairoBold(
                    fontSize: 11.5,
                    color: AppPalette.imperialGold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              ...List.generate(data.categories.length, (i) {
                return AssetCategoryCard(
                  category: data.categories[i],
                  icon: _categoryIcons[i % _categoryIcons.length],
                  primaryColor: primaryAccent,
                  onTap: () => provider.setSelectedTab(AppTab.hierarchy),
                );
              }),

              // Bottom padding for floating nav dock
              const SizedBox(height: 110),
            ],
          ),
        );
      },
    );
  }

  // ── Search + Add Row ────────────────────────────────────────────────────────
  Widget _buildSearchAddRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RoyalGlassContainer(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            borderRadius: 16,
            backgroundColor: AppPalette.surfaceDark.withValues(alpha: 0.7),
            border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: AppPalette.primary,
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private Section Header
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color accentColor;
  final Widget trailing;

  const _SectionHeader({
    required this.title,
    required this.accentColor,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.4),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTypography.cairoBold(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        trailing,
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Multi-View Button
// ─────────────────────────────────────────────────────────────────────────────

class _MultiViewButton extends StatelessWidget {
  final AegisProvider provider;

  const _MultiViewButton({required this.provider});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        provider.setSelectedTab(AppTab.multiGrid);
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'عرض متعدد',
              style: AppTypography.cairoBold(
                fontSize: 11,
                color: AppPalette.primary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.grid_view_rounded,
              size: 14,
              color: AppPalette.primary,
            ),
          ],
        ),
      ),
    );
  }
}
