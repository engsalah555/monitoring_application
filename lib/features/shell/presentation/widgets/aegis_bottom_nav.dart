import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../surveillance_system/domain/entities/app_tab.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';

/// Cybernetic Glassmorphic Navigation Dock with Central Prominent Floating Command Orb.
class AegisBottomNav extends StatelessWidget {
  const AegisBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Selector<AegisProvider, ({int index, bool isEmergency})>(
      selector: (_, p) => (
        index: p.selectedTabIndex,
        isEmergency: p.isEmergency,
      ),
      builder: (context, state, child) {
        final primaryColor = AppColors.getPrimary(state.isEmergency);
        final primaryDimColor = AppColors.getPrimaryDim(state.isEmergency);
        final isCommandActive = state.index == AppTab.command.index;

        return RepaintBoundary(
          child: Padding(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: bottomPadding > 0 ? bottomPadding + 4 : 12,
              top: 4,
            ),
            child: SizedBox(
              height: 72,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  // Floating Glass Dock Base Container
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 60,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.15),
                            blurRadius: 20,
                            spreadRadius: 1,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.panel.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: primaryColor.withValues(alpha: 0.28),
                                width: 1.2,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              children: [
                                // Left Side Tabs: Hierarchy & Live Single
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _NavTabItem(
                                        tab: AppTab.hierarchy,
                                        isSelected: state.index == AppTab.hierarchy.index,
                                        primaryColor: primaryColor,
                                        primaryDimColor: primaryDimColor,
                                      ),
                                      _NavTabItem(
                                        tab: AppTab.liveSingle,
                                        isSelected: state.index == AppTab.liveSingle.index,
                                        primaryColor: primaryColor,
                                        primaryDimColor: primaryDimColor,
                                      ),
                                    ],
                                  ),
                                ),

                                // Center Spacer for Raised Command Orb Button
                                const SizedBox(width: 58),

                                // Right Side Tabs: Archive & Settings
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _NavTabItem(
                                        tab: AppTab.archive,
                                        isSelected: state.index == AppTab.archive.index,
                                        primaryColor: primaryColor,
                                        primaryDimColor: primaryDimColor,
                                      ),
                                      _NavTabItem(
                                        tab: AppTab.settings,
                                        isSelected: state.index == AppTab.settings.index,
                                        primaryColor: primaryColor,
                                        primaryDimColor: primaryDimColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Center Raised Floating Command Orb Button
                  Positioned(
                    top: 0,
                    child: _CentralCommandOrb(
                      isActive: isCommandActive,
                      primaryColor: primaryColor,
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        context.read<AegisProvider>().setSelectedTab(AppTab.command);
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

/// Prominent Raised Floating Cybernetic Command Orb Button.
class _CentralCommandOrb extends StatelessWidget {
  final bool isActive;
  final Color primaryColor;
  final VoidCallback onTap;

  const _CentralCommandOrb({
    required this.isActive,
    required this.primaryColor,
    required this.onTap,
  });

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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isActive
                    ? [primaryColor, const Color(0xFF1B4B5C)]
                    : [AppColors.panelRaised, AppColors.panel],
              ),
              border: Border.all(
                color: isActive ? Colors.white : primaryColor.withValues(alpha: 0.5),
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: isActive ? 0.45 : 0.2),
                  blurRadius: isActive ? 16 : 8,
                  spreadRadius: isActive ? 2 : 0,
                ),
              ],
            ),
            child: Icon(
              Icons.dashboard_rounded,
              color: isActive ? Colors.black : primaryColor,
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
  final Color primaryColor;
  final Color primaryDimColor;

  const _NavTabItem({
    required this.tab,
    required this.isSelected,
    required this.primaryColor,
    required this.primaryDimColor,
  });

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
        splashColor: primaryColor.withValues(alpha: 0.15),
        highlightColor: primaryColor.withValues(alpha: 0.08),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? primaryDimColor : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? primaryColor.withValues(alpha: 0.35)
                  : Colors.transparent,
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isSelected ? tab.activeIcon : tab.icon,
                  color: isSelected ? primaryColor : AppColors.textTertiary,
                  size: 20,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: isSelected
                    ? AppTypography.cairoBold(
                        fontSize: 9.5,
                        color: primaryColor,
                      )
                    : AppTypography.cairoSemiBold(
                        fontSize: 9.0,
                        color: AppColors.textTertiary,
                      ),
                child: Text(
                  tab.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
