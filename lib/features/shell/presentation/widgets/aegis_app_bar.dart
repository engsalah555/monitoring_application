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
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkIndigo,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        child: Selector<AegisProvider, ({bool isEmergency, int alertCount})>(
          selector: (_, p) =>
              (isEmergency: p.isEmergency, alertCount: p.alertCount),
          builder: (context, state, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Executive Logo & Subtitle
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(alpha: 0.4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.videocam_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.brandTitle,
                          style: AppTypography.cairoBold(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          AppStrings.brandSubtitle,
                          style: AppTypography.cairoRegular(
                            fontSize: 10,
                            color: AppColors.textLightSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Header Actions
                Row(
                  children: [
                    // Alerts Counter Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: state.isEmergency
                            ? AppColors.red.withValues(alpha: 0.2)
                            : AppColors.amber.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: state.isEmergency
                              ? AppColors.red
                              : AppColors.amber,
                        ),
                      ),
                      child: Text(
                        '${state.alertCount} تنبيهات',
                        style: AppTypography.cairoBold(
                          fontSize: 11,
                          color: state.isEmergency
                              ? AppColors.red
                              : AppColors.amber,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Toggle Emergency Mode Button
                    InkWell(
                      onTap: () =>
                          context.read<AegisProvider>().toggleEmergencyMode(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: state.isEmergency
                              ? AppColors.red
                              : AppColors.darkIndigoSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: state.isEmergency
                                ? AppColors.red
                                : Colors.white12,
                          ),
                        ),
                        child: Text(
                          state.isEmergency
                              ? AppStrings.emergencyCancel
                              : AppStrings.emergencySimulate,
                          style: AppTypography.cairoBold(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    // Settings Icon Button
                    IconButton(
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () => context
                          .read<AegisProvider>()
                          .setSelectedTab(AppTab.settings),
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
