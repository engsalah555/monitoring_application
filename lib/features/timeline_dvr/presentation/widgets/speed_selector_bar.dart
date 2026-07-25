import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';
import '../../../surveillance_system/presentation/controllers/telemetry_notifier.dart';

/// Speed Selector Bar Widget for DVR Playback (1x, 2x, 4x, 8x).
class SpeedSelectorBar extends StatelessWidget {
  const SpeedSelectorBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isEmergency =
        context.select<AegisProvider, bool>((p) => p.isEmergency);
    final primaryColor = AppColors.getPrimary(isEmergency);

    return Selector<TelemetryNotifier, String>(
      selector: (_, t) => t.playbackSpeed,
      builder: (context, currentSpeed, child) {
        return Row(
          children: ['1x', '2x', '4x', '8x'].map((speed) {
            final isSelected = currentSpeed == speed;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () => context
                      .read<TelemetryNotifier>()
                      .setPlaybackSpeed(speed),
                  borderRadius: BorderRadius.circular(9),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.getPrimaryDim(isEmergency)
                          : AppColors.panel,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: isSelected ? primaryColor : AppColors.panelLine,
                      ),
                    ),
                    child: Text(
                      speed,
                      textAlign: TextAlign.center,
                      style: AppTypography.monoBold(
                        fontSize: 11,
                        color: isSelected
                            ? primaryColor
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
