import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/radar_avatar_ring.dart';

/// Reusable Favorite Camera Radar Ring Item.
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
            size: 64,
            borderColor: color,
            isAlert: isAlert,
            child: Container(
              color: AppColors.panelRaised,
              child: Icon(Icons.videocam_outlined, color: color, size: 22),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.cairoRegular(
              fontSize: 10.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
