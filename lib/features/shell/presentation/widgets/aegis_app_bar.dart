import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../surveillance_system/domain/entities/app_tab.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';

/// Clean, decoupled App Bar widget for AEGIS Command Center.
class AegisAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AegisAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.panel.withValues(alpha: 0.85),
        border: const Border(
          bottom: BorderSide(color: AppColors.panelLine, width: 1.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: SafeArea(
        child: Selector<AegisProvider, ({bool isEmergency, int alertCount})>(
          selector: (_, p) =>
              (isEmergency: p.isEmergency, alertCount: p.alertCount),
          builder: (context, state, child) {
            final primaryColor = AppColors.getPrimary(state.isEmergency);

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Executive Logo & Subtitle
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [
                            primaryColor,
                            const Color(0xFF1B4B5C),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'A',
                          style: AppTypography.cairoBold(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.brandTitle,
                          style: AppTypography.cairoBold(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          AppStrings.brandSubtitle,
                          style: AppTypography.cairoRegular(
                            fontSize: 9.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Executive Header Actions & Emergency Mode Trigger & Settings Trigger
                Row(
                  children: [
                    // Alerts Counter Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: state.isEmergency
                            ? AppColors.redDim
                            : AppColors.amberDim,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: state.isEmergency
                              ? AppColors.red
                              : AppColors.amber,
                        ),
                      ),
                      child: Text(
                        '${state.alertCount} تنبيهات',
                        style: AppTypography.cairoBold(
                          fontSize: 10.5,
                          color: state.isEmergency
                              ? AppColors.red
                              : AppColors.amber,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Toggle Emergency Mode Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.isEmergency
                            ? AppColors.redDim
                            : AppColors.panelRaised,
                        foregroundColor: state.isEmergency
                            ? Colors.white
                            : AppColors.textPrimary,
                        side: BorderSide(
                          color: state.isEmergency
                              ? AppColors.red
                              : AppColors.panelLine,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () =>
                          context.read<AegisProvider>().toggleEmergencyMode(),
                      child: Text(
                        state.isEmergency
                            ? AppStrings.emergencyCancel
                            : AppStrings.emergencySimulate,
                        style: AppTypography.cairoBold(
                          fontSize: 10.5,
                          color: state.isEmergency
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    // Direct Settings Button Trigger
                    IconButton(
                      icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary, size: 20),
                      onPressed: () => context.read<AegisProvider>().setSelectedTab(AppTab.settings),
                      tooltip: 'إعدادات المنظومة',
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
