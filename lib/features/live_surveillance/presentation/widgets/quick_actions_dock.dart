import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/build_context_x.dart';
import '../../../../core/theme/app_colors.dart';

/// Floating Quick Actions Dock Widget (Bottom Left on Camera Feed).
class QuickActionsDock extends StatelessWidget {
  const QuickActionsDock({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDockBtn(
          icon: Icons.camera_alt_outlined,
          color: AppColors.textPrimary,
          onTap: () {
            context.showSnackBar(
              AppStrings.screenshotCaptured,
              backgroundColor: AppColors.panelRaised,
            );
          },
        ),
        const SizedBox(height: 12),
        _buildDockBtn(
          icon: Icons.fiber_manual_record,
          color: AppColors.red,
          onTap: () {
            context.showSnackBar(
              AppStrings.recordingStarted,
              backgroundColor: AppColors.red,
            );
          },
        ),
        const SizedBox(height: 12),
        _buildDockBtn(
          icon: Icons.share_outlined,
          color: AppColors.textPrimary,
          onTap: () {
            context.showSnackBar(
              AppStrings.linkShared,
              backgroundColor: AppColors.panelRaised,
            );
          },
        ),
      ],
    );
  }

  Widget _buildDockBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.panel.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.panelLine),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 20),
        onPressed: onTap,
      ),
    );
  }
}
