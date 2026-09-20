import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/timeline_scrubber.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';
import '../../../surveillance_system/presentation/controllers/telemetry_notifier.dart';
import '../widgets/camguard_event_history_list.dart';
import '../widgets/dvr_player_header.dart';
import '../widgets/dvr_transport_controls.dart';
import '../widgets/speed_selector_bar.dart';

/// Screen 5: CamGuard DVR Playback and Timeline archive playback screen with Event History.
class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isEmergency =
        context.select<AegisProvider, bool>((p) => p.isEmergency);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const DvrPlayerHeader(),

          // Timeline Controls & Scrubber Body
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Column(
              children: [
                // Date picker row
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppPalette.surfaceDark,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_right_rounded,
                            color: AppPalette.camGuardBlue),
                        onPressed: () {},
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 15, color: AppPalette.camGuardBlue),
                          const SizedBox(width: 8),
                          Text(
                            AppStrings.todayDate,
                            style: AppTypography.cairoBold(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_left_rounded,
                            color: AppPalette.camGuardBlue),
                        onPressed: () {},
                      ),
                    ],
                  ),
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
                const SizedBox(height: 16),

                const SpeedSelectorBar(),
                const SizedBox(height: 16),

                const DvrTransportControls(),
                const SizedBox(height: 20),

                // CamGuard Event History List
                CamGuardEventHistoryList(
                  onSelectEvent: (pos) {
                    context.read<TelemetryNotifier>().setTimelinePlayhead(pos);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم الانتقال إلى توقيت الحدث المسجل وبدء العرض'),
                        duration: Duration(milliseconds: 1400),
                        backgroundColor: AppPalette.surfaceDark,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
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
                const SizedBox(height: 90), // Space for floating bottom nav
              ],
            ),
          ),
        ],
      ),
    );
  }
}
