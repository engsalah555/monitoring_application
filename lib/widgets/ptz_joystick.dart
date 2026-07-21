import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class PtzJoystickWidget extends StatelessWidget {
  final Function(double pan, double tilt) onPanTilt;
  final VoidCallback onZoomIn;
  final bool isEmergency;

  const PtzJoystickWidget({
    super.key,
    required this.onPanTilt,
    required this.onZoomIn,
    this.isEmergency = false,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.getPrimary(isEmergency);

    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Ring
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.25),
                width: 1.5,
              ),
              color: AppColors.panel.withValues(alpha: 0.6),
            ),
          ),
          // Mid Ring
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.4),
                width: 1.2,
              ),
            ),
          ),
          // Core Zoom Button
          GestureDetector(
            onTap: onZoomIn,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.panelRaised,
                border: Border.all(
                  color: primaryColor,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Center(
                child: Text(
                  'تقريب',
                  style: GoogleFonts.cairo(
                    color: primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Up Arrow (N)
          Positioned(
            top: 4,
            child: GestureDetector(
              onTap: () => onPanTilt(0, 0.5),
              child: const Icon(Icons.arrow_drop_up, color: AppColors.textSecondary, size: 24),
            ),
          ),
          // Down Arrow (S)
          Positioned(
            bottom: 4,
            child: GestureDetector(
              onTap: () => onPanTilt(0, -0.5),
              child: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary, size: 24),
            ),
          ),
          // Right Arrow (E)
          Positioned(
            right: 4,
            child: GestureDetector(
              onTap: () => onPanTilt(0.5, 0),
              child: const Icon(Icons.arrow_right, color: AppColors.textSecondary, size: 24),
            ),
          ),
          // Left Arrow (W)
          Positioned(
            left: 4,
            child: GestureDetector(
              onTap: () => onPanTilt(-0.5, 0),
              child: const Icon(Icons.arrow_left, color: AppColors.textSecondary, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
