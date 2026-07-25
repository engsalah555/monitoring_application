import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Reusable Interactive Floor Map Placeholder View.
class FloorMapView extends StatelessWidget {
  final Color primaryColor;

  const FloorMapView({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.map_outlined, color: primaryColor, size: 48),
          const SizedBox(height: 12),
          Text(
            AppStrings.interactiveFloorMap,
            style: AppTypography.cairoRegular(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
