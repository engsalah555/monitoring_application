import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/royal/royal_glass.dart';
import '../../../surveillance_system/domain/entities/app_tab.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';

/// Royal Floating Frosted Glass Navigation Dock with Center Command Jewel Orb.
class AegisBottomNav extends StatelessWidget {
  const AegisBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Selector<AegisProvider, ({int index, bool isEmergency})>(
      selector: (_, p) =>
          (index: p.selectedTabIndex, isEmergency: p.isEmergency),
      builder: (context, state, child) {
        final isCommandActive = state.index == AppTab.command.index;

        return RepaintBoundary(
          child: Padding(
            padding: EdgeInsets.only(
              left: 14,
              right: 14,
              bottom: bottomPadding > 0 ? bottomPadding + 6 : 14,
              top: 4,
            ),
            child: SizedBox(
              height: 76,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  // Floating Royal Frosted Glass Dock Container
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 66,
                    child: RoyalGlassContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      borderRadius: 30,
                      blur: 24,
                      backgroundColor: AppPalette.surfaceDark.withValues(alpha: 0.85),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.14),
                        width: 1.2,
                      ),
                      shadows: AppPalette.floatingDockShadow,
                      child: Row(
                        children: [
                          // Left Side Tabs
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _RoyalNavTabItem(
                                  tab: AppTab.hierarchy,
                                  isSelected:
                                      state.index == AppTab.hierarchy.index,
                                ),
                                _RoyalNavTabItem(
                                  tab: AppTab.liveSingle,
                                  isSelected:
                                      state.index == AppTab.liveSingle.index,
                                ),
                              ],
                            ),
                          ),

                          // Spacer for Central Raised Command Button
                          const SizedBox(width: 64),

                          // Right Side Tabs
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _RoyalNavTabItem(
                                  tab: AppTab.archive,
                                  isSelected:
                                      state.index == AppTab.archive.index,
                                ),
                                _RoyalNavTabItem(
                                  tab: AppTab.settings,
                                  isSelected:
                                      state.index == AppTab.settings.index,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Center Raised Floating Royal Command Jewel Orb
                  Positioned(
                    top: 0,
                    child: _RoyalCommandJewelOrb(
                      isActive: isCommandActive,
                      isEmergency: state.isEmergency,
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        context.read<AegisProvider>().setSelectedTab(
                              AppTab.command,
                            );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RoyalCommandJewelOrb extends StatelessWidget {
  final bool isActive;
  final bool isEmergency;
  final VoidCallback onTap;

  const _RoyalCommandJewelOrb({
    required this.isActive,
    required this.isEmergency,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      label: 'غرفة القيادة والسيطرة التنفيذية',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: isActive ? 1.12 : 1.0,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutBack,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isEmergency
                  ? AppPalette.emergencyGradient
                  : AppPalette.royalSapphireGradient,
              border: Border.all(
                color: isEmergency
                    ? AppPalette.crimsonAlert
                    : (isActive ? AppPalette.imperialGold : Colors.white24),
                width: 1.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isEmergency
                          ? AppPalette.crimsonAlert
                          : AppPalette.primary)
                      .withValues(alpha: 0.5),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(-2, -2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                isActive
                    ? Icons.grid_view_rounded
                    : Icons.dashboard_outlined,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoyalNavTabItem extends StatelessWidget {
  final AppTab tab;
  final bool isSelected;

  const _RoyalNavTabItem({required this.tab, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: tab.label,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          context.read<AegisProvider>().setSelectedTab(tab);
        },
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppPalette.primary.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            border: isSelected
                ? Border.all(
                    color: AppPalette.primary.withValues(alpha: 0.35),
                    width: 1,
                  )
                : Border.all(color: Colors.transparent, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? tab.activeIcon : tab.icon,
                color: isSelected
                    ? AppPalette.cyanLight
                    : AppPalette.textLightMuted,
                size: 22,
              ),
              const SizedBox(height: 2),
              Text(
                tab.label,
                style: isSelected
                    ? AppTypography.cairoBold(
                        fontSize: 10,
                        color: AppPalette.cyanLight,
                      )
                    : AppTypography.cairoRegular(
                        fontSize: 9.5,
                        color: AppPalette.textLightMuted,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
