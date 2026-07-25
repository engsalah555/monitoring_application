import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// HUD Night Vision & Telemetry Overlay Widget.
class HudOverlayWidget extends StatefulWidget {
  final String cameraName;
  final String telemetryText;
  final bool isOffline;
  final bool isEmergency;

  const HudOverlayWidget({
    super.key,
    required this.cameraName,
    required this.telemetryText,
    this.isOffline = false,
    this.isEmergency = false,
  });

  @override
  State<HudOverlayWidget> createState() => _HudOverlayWidgetState();
}

class _HudOverlayWidgetState extends State<HudOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.getPrimary(widget.isEmergency);

    if (widget.isOffline) {
      return Container(
        color: Colors.black.withValues(alpha: 0.85),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.videocam_off_outlined,
                  color: AppColors.textTertiary, size: 36),
              const SizedBox(height: 8),
              Text(
                'غير متصل — NO FEED',
                style: AppTypography.monoBold(
                    fontSize: 12, color: AppColors.textTertiary),
              ),
            ],
          ),
        ),
      );
    }

    return RepaintBoundary(
      child: Stack(
        children: [
          // Subtle scanlines overlay isolated in RepaintBoundary
          Positioned.fill(
            child: CustomPaint(
              painter: ScanlinePainter(
                  color: primaryColor.withValues(alpha: 0.04)),
            ),
          ),
          // HUD Bounding Frame Box
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
          ),
          // Top HUD controls
          Positioned(
            top: 14,
            left: 14,
            right: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // REC badge with blinking red dot
                Row(
                  children: [
                    FadeTransition(
                      opacity: _blinkController,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.red.withValues(alpha: 0.8),
                              blurRadius: 6,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'REC',
                      style: AppTypography.monoBold(
                          fontSize: 10, color: AppColors.red),
                    ),
                  ],
                ),
                Text(
                  'FPS: 60 · HD 1080p',
                  style: AppTypography.monoSemiBold(
                      fontSize: 9, color: primaryColor),
                ),
              ],
            ),
          ),
          // Bottom Telemetry Overlay
          Positioned(
            bottom: 14,
            left: 14,
            right: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.telemetryText,
                  style: AppTypography.monoRegular(
                    fontSize: 9,
                    color: primaryColor.withValues(alpha: 0.85),
                  ),
                ),
                Text(
                  widget.cameraName,
                  style: AppTypography.monoBold(
                    fontSize: 10,
                    color: AppColors.textPrimary,
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

class ScanlinePainter extends CustomPainter {
  final Color color;
  const ScanlinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
