import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../state/aegis_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/timeline_scrubber.dart';

/// Screen 5: DVR Playback and Timeline archive playback screen.
class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AegisProvider>(context);
    final primaryColor = AppColors.getPrimary(provider.isEmergency);

    return Column(
      children: [
        // Video Preview Container
        Container(
          height: 210,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.panelRaised,
            border: Border(bottom: BorderSide(color: AppColors.panelLine, width: 1.5)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Play icon inside circle
              GestureDetector(
                onTap: () => provider.toggleTimelinePlay(),
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
                      provider.isTimelinePlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: AppColors.bgVoid,
                      size: 26,
                    ),
                  ),
                ),
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
                      'سجل ARCHIVE',
                      style: GoogleFonts.ibmPlexMono(
                        color: primaryColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'CAM-14',
                      style: GoogleFonts.ibmPlexMono(
                        color: primaryColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

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
                      'اليوم · ١٣ يوليو ٢٠٢٦',
                      style: GoogleFonts.cairo(
                        color: AppColors.textPrimary,
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
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
                TimelineScrubberWidget(
                  playheadPos: provider.timelinePlayhead,
                  isEmergency: provider.isEmergency,
                  onSeek: (pos) {
                    provider.setTimelinePlayhead(pos);
                  },
                ),
                const SizedBox(height: 18),

                // Speed Selector Chips
                Row(
                  children: ['1x', '2x', '4x', '8x'].map((speed) {
                    final isSelected = provider.playbackSpeed == speed;
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () => provider.setPlaybackSpeed(speed),
                          borderRadius: BorderRadius.circular(9),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.getPrimaryDim(provider.isEmergency)
                                  : AppColors.panel,
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(
                                color: isSelected
                                    ? primaryColor
                                    : AppColors.panelLine,
                              ),
                            ),
                            child: Text(
                              speed,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ibmPlexMono(
                                color: isSelected
                                    ? primaryColor
                                    : AppColors.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // DVR Player Transport Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => provider.adjustTimeline(-5),
                      child: Text(
                        '-١٥ث',
                        style: GoogleFonts.cairo(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 28),
                    GestureDetector(
                      onTap: () => provider.toggleTimelinePlay(),
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
                          provider.isTimelinePlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: AppColors.bgVoid,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 28),
                    GestureDetector(
                      onTap: () => provider.adjustTimeline(5),
                      child: Text(
                        '+١٥ث',
                        style: GoogleFonts.cairo(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

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
                      'أرشيف DVR · الاحتفاظ بالتسجيلات لمدة ٣٠ يوماً',
                      style: GoogleFonts.cairo(
                        color: AppColors.textTertiary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
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
