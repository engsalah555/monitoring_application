import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/neumorphic_decorations.dart';
import '../../../surveillance_system/domain/entities/app_tab.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';

/// Cybernetic Glassmorphic Navigation Dock with Central Prominent Floating Command Orb.
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
              top: 6,
            ),
            child: SizedBox(
              height: 74,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  // Floating Neumorphic Dock Container
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 64,
                    child: Container(
                      decoration: NeumorphicDecorations.softRaised(
                        color: AppColors.clayCard,
                        borderRadius: 32,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(
                        children: [
                          // Left Side Tabs
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _NavTabItem(
                                  tab: AppTab.hierarchy,
                                  isSelected:
                                      state.index == AppTab.hierarchy.index,
                                ),
                                _NavTabItem(
                                  tab: AppTab.liveSingle,
                                  isSelected:
                                      state.index == AppTab.liveSingle.index,
                                ),
                              ],
                            ),
                          ),

                          // Spacer for Raised Command Button
                          const SizedBox(width: 60),

                          // Right Side Tabs
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _NavTabItem(
                                  tab: AppTab.archive,
                                  isSelected:
                                      state.index == AppTab.archive.index,
                                ),
                                _NavTabItem(
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

                  // Center Raised Floating Neumorphic Command Button
                  Positioned(
                    top: 0,
                    child: _CentralCommandOrb(
                      isActive: isCommandActive,
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

class _CentralCommandOrb extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _CentralCommandOrb({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      label: 'غرفة القيادة الرئيسية',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: isActive ? 1.12 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.45),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.8),
                  blurRadius: 8,
                  offset: const Offset(-3, -3),
                ),
              ],
            ),
            child: const Icon(
              Icons.dashboard_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTabItem extends StatelessWidget {
  final AppTab tab;
  final bool isSelected;

  const _NavTabItem({required this.tab, required this.isSelected});

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
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          decoration: isSelected
              ? BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                )
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? tab.activeIcon : tab.icon,
                color: isSelected
                    ? AppColors.primaryBlue
                    : AppColors.textDarkTertiary,
                size: 22,
              ),
              const SizedBox(height: 2),
              Text(
                tab.label,
                style: isSelected
                    ? AppTypography.cairoBold(
                        fontSize: 10,
                        color: AppColors.primaryBlue,
                      )
                    : AppTypography.cairoSemiBold(
                        fontSize: 9.5,
                        color: AppColors.textDarkTertiary,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
