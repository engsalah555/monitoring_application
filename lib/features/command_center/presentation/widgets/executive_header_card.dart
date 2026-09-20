import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/radar_avatar_ring.dart';
import '../../../../core/widgets/royal/royal_glass.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';

/// Royal Executive Header Status Card Widget.
class ExecutiveHeaderCard extends StatelessWidget {
  const ExecutiveHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<AegisProvider, ({bool isEmergency, String statusText})>(
      selector: (_, p) =>
          (isEmergency: p.isEmergency, statusText: p.systemStatusText),
      builder: (context, state, child) {
        final statusColor =
            state.isEmergency ? AppPalette.crimsonAlert : AppPalette.emeraldLive;

        return RoyalGlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          borderRadius: 18,
          backgroundColor: AppPalette.surfaceDark.withValues(alpha: 0.82),
          border: Border.all(
            color: state.isEmergency
                ? AppPalette.crimsonAlert.withValues(alpha: 0.4)
                : AppPalette.borderGlow,
            width: 1.2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppStrings.greetingUser,
                        style: AppTypography.cairoBold(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppPalette.imperialGold
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppPalette.imperialGold
                                .withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          'الرئيس التنفيذي',
                          style: AppTypography.cairoBold(
                            fontSize: 10,
                            color: AppPalette.imperialGold,
                          ),
                        ),
                      ),
                    ],
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
                              color: statusColor.withValues(alpha: 0.7),
                              blurRadius: 8,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.statusText,
                        style: AppTypography.cairoRegular(
                          fontSize: 11.5,
                          color: AppPalette.textLightSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Royal Avatar with Radar Glow Ring
              RadarRingWidget(
                size: 48,
                borderColor: AppPalette.primary,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppPalette.royalSapphireGradient,
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
