import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/radar_avatar_ring.dart';

/// Reusable Royal Favorite Camera Radar Ring Item.
class FavoriteCameraItem extends StatelessWidget {
  final String label;
  final Color color;
  final bool isAlert;
  final VoidCallback onTap;

  const FavoriteCameraItem({
    super.key,
    required this.label,
    required this.color,
    this.isAlert = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          RadarRingWidget(
            size: 68,
            borderColor: color,
            isAlert: isAlert,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    AppPalette.cardElevatedDark,
                    AppPalette.surfaceDark,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: color.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Icon(Icons.videocam_rounded, color: color, size: 26),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 78,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.cairoBold(
                fontSize: 11.5,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
