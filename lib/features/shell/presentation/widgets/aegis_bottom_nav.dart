import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../surveillance_system/domain/entities/app_tab.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';

/// Obsidian Floating Capsule Navigation Dock — inspired by IMG_8105.WEBP.
///
/// • Matte obsidian pill background (`#16161F`)
/// • Active tab: white capsule pill with dark icon/label
/// • Inactive tabs: muted grey icon/label
/// • Centre Jewel Orb: violet gradient, raised above the dock
/// • Zero `const` violations — all colour references are from AppPalette
class AegisBottomNav extends StatelessWidget {
  const AegisBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Selector<AegisProvider, ({int index, bool isEmergency})>(
      selector: (_, p) =>
          (index: p.selectedTabIndex, isEmergency: p.isEmergency),
      builder: (context, state, _) {
        final isCommandActive = state.index == AppTab.command.index;

        return RepaintBoundary(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: bottomPadding > 0 ? bottomPadding + 8 : 16,
              top: 4,
            ),
            child: SizedBox(
              height: 80,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  // ── Obsidian Dock Pill ────────────────────────────────────
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 68,
                    child: _ObsidianDock(state: state),
                  ),

                  // ── Centre Raised Violet Jewel Orb ────────────────────────
                  Positioned(
                    top: 0,
                    child: _VioletCommandOrb(
                      isActive: isCommandActive,
                      isEmergency: state.isEmergency,
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        context
                            .read<AegisProvider>()
                            .setSelectedTab(AppTab.command);
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

// ─────────────────────────────────────────────────────────────────────────────
// Obsidian Dock Container
// ─────────────────────────────────────────────────────────────────────────────

class _ObsidianDock extends StatelessWidget {
  final ({int index, bool isEmergency}) state;

  const _ObsidianDock({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.dockBackground,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: AppPalette.borderDark,
          width: 1,
        ),
        boxShadow: AppPalette.floatingDockShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          // Left tabs: Hierarchy · Live
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CapsuleNavItem(
                  tab: AppTab.hierarchy,
                  isSelected: state.index == AppTab.hierarchy.index,
                ),
                _CapsuleNavItem(
                  tab: AppTab.liveSingle,
                  isSelected: state.index == AppTab.liveSingle.index,
                ),
              ],
            ),
          ),

          // Gap for the raised centre orb
          const SizedBox(width: 68),

          // Right tabs: Archive · Settings
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CapsuleNavItem(
                  tab: AppTab.archive,
                  isSelected: state.index == AppTab.archive.index,
                ),
                _CapsuleNavItem(
                  tab: AppTab.settings,
                  isSelected: state.index == AppTab.settings.index,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Capsule Nav Item  (White pill when selected, transparent when not)
// ─────────────────────────────────────────────────────────────────────────────

class _CapsuleNavItem extends StatelessWidget {
  final AppTab tab;
  final bool isSelected;

  const _CapsuleNavItem({required this.tab, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: tab.label,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          context.read<AegisProvider>().setSelectedTab(tab);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: isSelected
              ? const EdgeInsets.symmetric(horizontal: 14, vertical: 6)
              : const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppPalette.dockActivePill : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? tab.activeIcon : tab.icon,
                size: 19,
                color: isSelected
                    ? AppPalette.dockActiveIcon
                    : AppPalette.dockInactiveIcon,
              ),
              // Smooth label reveal on selection
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                child: isSelected
                    ? Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          tab.label,
                          style: AppTypography.cairoBold(
                            fontSize: 10.5,
                            color: AppPalette.dockActiveIcon,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Violet Command Orb  (raised above the dock, centre position)
// ─────────────────────────────────────────────────────────────────────────────

class _VioletCommandOrb extends StatelessWidget {
  final bool isActive;
  final bool isEmergency;
  final VoidCallback onTap;

  const _VioletCommandOrb({
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
          scale: isActive ? 1.10 : 1.0,
          duration: const Duration(milliseconds: 270),
          curve: Curves.easeOutBack,
          child: Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isEmergency
                  ? AppPalette.emergencyGradient
                  : AppPalette.violetGradient,
              border: Border.all(
                color: isEmergency
                    ? AppPalette.crimsonAlert.withValues(alpha: 0.7)
                    : Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isEmergency
                          ? AppPalette.crimsonAlert
                          : AppPalette.primary)
                      .withValues(alpha: isActive ? 0.55 : 0.35),
                  blurRadius: 22,
                  spreadRadius: isActive ? 2 : 0,
                  offset: const Offset(0, 6),
                ),
                // Subtle top specular highlight
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.12),
                  blurRadius: 6,
                  offset: const Offset(-1, -1),
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
