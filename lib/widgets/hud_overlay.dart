import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

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
              const Icon(Icons.videocam_off_outlined, color: AppColors.textTertiary, size: 36),
              const SizedBox(height: 8),
              Text(
                'غير متصل — NO FEED',
                style: GoogleFonts.ibmPlexMono(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Subtle scanlines overlay
        Positioned.fill(
          child: CustomPaint(
            painter: ScanlinePainter(color: primaryColor.withValues(alpha: 0.04)),
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
                    style: GoogleFonts.ibmPlexMono(
                      color: AppColors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                'FPS: 60 · HD 1080p',
                style: GoogleFonts.ibmPlexMono(
                  color: primaryColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
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
                style: GoogleFonts.ibmPlexMono(
                  color: primaryColor.withValues(alpha: 0.85),
                  fontSize: 9,
                ),
              ),
              Text(
                widget.cameraName,
                style: GoogleFonts.ibmPlexMono(
                  color: AppColors.textPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ScanlinePainter extends CustomPainter {
  final Color color;
  ScanlinePainter({required this.color});

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
