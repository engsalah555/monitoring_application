import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Interactive Timeline DVR Scrubber Bar Widget.
class TimelineScrubberWidget extends StatelessWidget {
  final double playheadPos; // 0 to 100
  final ValueChanged<double> onSeek;
  final bool isEmergency;

  const TimelineScrubberWidget({
    super.key,
    required this.playheadPos,
    required this.onSeek,
    this.isEmergency = false,
  });

  void _handleGesture(Offset localPosition, Size size) {
    if (size.width <= 0) return;
    final pct = (localPosition.dx / size.width) * 100;
    onSeek(pct.clamp(0.0, 100.0));
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.getPrimary(isEmergency);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          slider: true,
          value: '${playheadPos.toStringAsFixed(0)}%',
          label: 'مؤشر زمن التسجيل',
          child: GestureDetector(
            onTapDown: (details) {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null) {
                _handleGesture(details.localPosition, box.size);
              }
            },
            onHorizontalDragUpdate: (details) {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null) {
                _handleGesture(details.localPosition, box.size);
              }
            },
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.panel,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.panelLine),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final playheadX = (playheadPos / 100) * width;

                  return Stack(
                    children: [
                      // Motion Event Ticks (Amber markers at 22%, 61%, 74%)
                      Positioned(
                        left: width * 0.22,
                        top: 0,
                        bottom: 0,
                        width: 4,
                        child: Container(color: AppColors.amber),
                      ),
                      Positioned(
                        left: width * 0.61,
                        top: 0,
                        bottom: 0,
                        width: 4,
                        child: Container(color: AppColors.amber),
                      ),
                      Positioned(
                        left: width * 0.74,
                        top: 0,
                        bottom: 0,
                        width: 4,
                        child: Container(color: AppColors.amber),
                      ),
                      // Cyan/Red Playhead Line
                      Positioned(
                        left: playheadX,
                        top: 0,
                        bottom: 0,
                        width: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor,
                                blurRadius: 8,
                              )
                            ],
                          ),
                        ),
                      ),
                      // Playhead Top Indicator Dot
                      Positioned(
                        left: (playheadX - 4).clamp(0, width - 10),
                        top: 0,
                        width: 10,
                        height: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const ['00', '03', '06', '09', '12', '15', '18', '21']
              .map(
                (hour) => Text(
                  hour,
                  style: AppTypography.monoRegular(
                    fontSize: 10,
                    color: AppColors.textTertiary,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
