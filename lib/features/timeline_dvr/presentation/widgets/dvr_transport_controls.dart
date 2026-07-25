import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../surveillance_system/presentation/controllers/telemetry_notifier.dart';

/// DVR Transport Controls Widget (Play/Pause, Step Backward, Step Forward).
class DvrTransportControls extends StatelessWidget {
  const DvrTransportControls({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<TelemetryNotifier>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => notifier.adjustTimeline(-5),
          child: Text(
            AppStrings.secBackward,
            style: AppTypography.cairoBold(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 28),
        Selector<TelemetryNotifier, bool>(
          selector: (_, t) => t.isTimelinePlaying,
          builder: (context, isPlaying, child) {
            return GestureDetector(
              onTap: () => notifier.toggleTimelinePlay(),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textPrimary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: AppColors.bgVoid,
                  size: 22,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 28),
        GestureDetector(
          onTap: () => notifier.adjustTimeline(5),
          child: Text(
            AppStrings.secForward,
            style: AppTypography.cairoBold(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
