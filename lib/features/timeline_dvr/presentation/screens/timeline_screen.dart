import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/timeline_scrubber.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';
import '../../../surveillance_system/presentation/controllers/telemetry_notifier.dart';
import '../widgets/dvr_player_header.dart';
import '../widgets/dvr_transport_controls.dart';
import '../widgets/speed_selector_bar.dart';

/// Screen 5: DVR Playback and Timeline archive playback screen.
class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isEmergency =
        context.select<AegisProvider, bool>((p) => p.isEmergency);

    return Column(
      children: [
        const DvrPlayerHeader(),

        // Timeline Controls & Scrubber Body
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // Date picker row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_right,
                          color: AppColors.textSecondary),
                      onPressed: () {},
                    ),
                    Text(
                      AppStrings.todayDate,
                      style: AppTypography.cairoBold(
                        fontSize: 13.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_left,
                          color: AppColors.textSecondary),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Interactive Timeline Scrubber Widget
                Selector<TelemetryNotifier, double>(
                  selector: (_, t) => t.timelinePlayhead,
                  builder: (context, playheadPos, child) {
                    return TimelineScrubberWidget(
                      playheadPos: playheadPos,
                      isEmergency: isEmergency,
                      onSeek: (pos) {
                        context
                            .read<TelemetryNotifier>()
                            .setTimelinePlayhead(pos);
                      },
                    );
                  },
                ),
                const SizedBox(height: 18),

                const SpeedSelectorBar(),
                const SizedBox(height: 20),

                const DvrTransportControls(),

                const Spacer(),
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.panelLine),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      AppStrings.archiveRetention,
                      style: AppTypography.cairoBold(
                        fontSize: 10,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
