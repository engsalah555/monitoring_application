import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/radar_avatar_ring.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';

/// Executive Header Status Card Widget.
class ExecutiveHeaderCard extends StatelessWidget {
  const ExecutiveHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<AegisProvider, ({bool isEmergency, String statusText})>(
      selector: (_, p) =>
          (isEmergency: p.isEmergency, statusText: p.systemStatusText),
      builder: (context, state, child) {
        final primaryColor = AppColors.getPrimary(state.isEmergency);
        final statusColor =
            state.isEmergency ? AppColors.red : AppColors.green;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.panel,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.panelLine),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.greetingUser,
                    style: AppTypography.cairoBold(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: statusColor,
                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withValues(alpha: 0.6),
                              blurRadius: 6,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        state.statusText,
                        style: AppTypography.cairoRegular(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Avatar with Radar Glow Ring
              RadarRingWidget(
                size: 44,
                borderColor: primaryColor,
                child: Container(
                  color: AppColors.panelRaised,
                  child: Center(
                    child: Text(
                      'أ ر',
                      style: AppTypography.cairoBold(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
