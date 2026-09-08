import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../surveillance_system/domain/entities/camera_node.dart';
import '../../../surveillance_system/domain/entities/camera_status.dart';

import '../../../../core/theme/neumorphic_decorations.dart';

/// Reusable Camera List Row Tile Widget.
class CameraRowTile extends StatelessWidget {
  final CameraNode camera;
  final bool isEmergency;
  final VoidCallback onTap;

  const CameraRowTile({
    super.key,
    required this.camera,
    required this.isEmergency,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOffline = camera.status == CameraStatus.offline;
    final isAlert = camera.status == CameraStatus.alert;

    final statusColor = isOffline
        ? AppColors.textDarkTertiary
        : (isAlert
            ? (isEmergency ? AppColors.red : AppColors.amber)
            : AppColors.primaryBlue);

    final statusText = isOffline
        ? 'غير متصل · منذ ساعتين'
        : (isAlert
            ? (isEmergency ? 'اختراق أمني · كشف حركة' : 'تنبيه حركة')
            : 'بث مباشر · بدقة ${camera.resolution}');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: NeumorphicDecorations.softRaised(
        color: AppColors.clayCard,
        borderRadius: 20,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isOffline
                        ? AppColors.clayBg
                        : AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Icon(
                      isOffline
                          ? Icons.videocam_off_rounded
                          : Icons.videocam_rounded,
                      color: statusColor,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        camera.name,
                        style: AppTypography.cairoBold(
                          fontSize: 13.5,
                          color: AppColors.textDarkPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: statusColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            statusText,
                            style: AppTypography.cairoRegular(
                              fontSize: 11,
                              color: AppColors.textDarkSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primaryBlue,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
