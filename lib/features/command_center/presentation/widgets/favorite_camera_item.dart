import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/radar_avatar_ring.dart';

import '../../../../core/theme/neumorphic_decorations.dart';

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
            size: 66,
            borderColor: color,
            isAlert: isAlert,
            child: Container(
              decoration: NeumorphicDecorations.softRaised(
                color: AppColors.clayCard,
                borderRadius: 22,
              ),
              child: Icon(Icons.videocam_rounded, color: color, size: 24),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.cairoSemiBold(
              fontSize: 11,
              color: AppColors.textDarkPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
