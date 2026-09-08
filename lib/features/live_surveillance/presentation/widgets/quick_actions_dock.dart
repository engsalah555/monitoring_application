import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/build_context_x.dart';
import '../../../../core/theme/app_colors.dart';

/// Floating Quick Actions Dock Widget (Bottom Left on Camera Feed).
class QuickActionsDock extends StatefulWidget {
  const QuickActionsDock({super.key});

  @override
  State<QuickActionsDock> createState() => _QuickActionsDockState();
}

class _QuickActionsDockState extends State<QuickActionsDock> {
  bool isHdMode = true;
  bool isMicActive = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDockBtn(
          icon: isHdMode ? Icons.hd_rounded : Icons.sd_rounded,
          color: isHdMode ? AppColors.cyan : AppColors.textSecondary,
          onTap: () {
            setState(() => isHdMode = !isHdMode);
            context.showSnackBar(
              isHdMode ? 'تم التبديل للبث عالي الدقة (Main Stream 4K)' : 'تم التبديل للبث السريع الموفر للبيانات (Sub Stream)',
              backgroundColor: AppColors.panelRaised,
            );
          },
        ),
        const SizedBox(height: 10),
        _buildDockBtn(
          icon: isMicActive ? Icons.mic_rounded : Icons.mic_off_rounded,
          color: isMicActive ? AppColors.green : AppColors.textSecondary,
          onTap: () {
            setState(() => isMicActive = !isMicActive);
            context.showSnackBar(
              isMicActive ? 'تم تفعيل التحدث الصوتي الثنائي' : 'تم كتم الميكروفون',
              backgroundColor: isMicActive ? AppColors.green : AppColors.panelRaised,
            );
          },
        ),
        const SizedBox(height: 10),
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
        const SizedBox(height: 10),
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
        const SizedBox(height: 10),
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
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.panel.withValues(alpha: 0.85),
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
