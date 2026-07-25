import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';
import '../../../surveillance_system/presentation/controllers/telemetry_notifier.dart';

/// Top DVR Video Player Preview Widget.
class DvrPlayerHeader extends StatelessWidget {
  const DvrPlayerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isEmergency =
        context.select<AegisProvider, bool>((p) => p.isEmergency);
    final primaryColor = AppColors.getPrimary(isEmergency);

    return Container(
      height: 210,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.panelRaised,
        border:
            Border(bottom: BorderSide(color: AppColors.panelLine, width: 1.5)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Play icon inside circle
          Selector<TelemetryNotifier, bool>(
            selector: (_, t) => t.isTimelinePlaying,
            builder: (context, isPlaying, child) {
              return GestureDetector(
                onTap: () =>
                    context.read<TelemetryNotifier>().toggleTimelinePlay(),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.textPrimary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: AppColors.bgVoid,
                      size: 26,
                    ),
                  ),
                ),
              );
            },
          ),
          // Top video HUD labels
          Positioned(
            top: 12,
            left: 14,
            right: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.archiveBadge,
                  style: AppTypography.monoBold(
                    fontSize: 11,
                    color: primaryColor,
                  ),
                ),
                Text(
                  'CAM-14',
                  style: AppTypography.monoBold(
                    fontSize: 11,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
