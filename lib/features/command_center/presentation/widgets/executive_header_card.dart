import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/radar_avatar_ring.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';

import '../../../../core/theme/neumorphic_decorations.dart';

/// Executive Header Status Card Widget.
class ExecutiveHeaderCard extends StatelessWidget {
  const ExecutiveHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<AegisProvider, ({bool isEmergency, String statusText})>(
      selector: (_, p) =>
          (isEmergency: p.isEmergency, statusText: p.systemStatusText),
      builder: (context, state, child) {
        final statusColor = state.isEmergency ? AppColors.red : AppColors.green;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: NeumorphicDecorations.softRaised(
            color: AppColors.clayCard,
            borderRadius: 24,
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
                      fontSize: 16.5,
                      color: AppColors.textDarkPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 9,
                        height: 9,
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
                      const SizedBox(width: 8),
                      Text(
                        state.statusText,
                        style: AppTypography.cairoRegular(
                          fontSize: 12,
                          color: AppColors.textDarkSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Avatar with Radar Glow Ring
              RadarRingWidget(
                size: 48,
                borderColor: AppColors.primaryBlue,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                  ),
                  child: Center(
                    child: Text(
                      'أ ر',
                      style: AppTypography.cairoBold(
                        fontSize: 14,
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
