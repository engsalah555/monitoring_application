import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../surveillance_system/domain/entities/camera_node.dart';
import '../../../surveillance_system/domain/entities/camera_status.dart';

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

    final primaryColor = AppColors.getPrimary(isEmergency);
    final statusColor = isOffline
        ? AppColors.textTertiary
        : (isAlert
            ? (isEmergency ? AppColors.red : AppColors.amber)
            : primaryColor);

    final statusText = isOffline
        ? 'غير متصل · منذ ساعتين'
        : (isAlert
            ? (isEmergency ? 'اختراق أمني · كشف حركة' : 'تنبيه حركة')
            : 'بث مباشر · بدقة ${camera.resolution}');

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.panelLine)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
        onTap: onTap,
        leading: Container(
          width: 60,
          height: 45,
          decoration: BoxDecoration(
            color: isOffline ? AppColors.bgPage : AppColors.panelRaised,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.panelLine),
          ),
          child: Center(
            child: Icon(
              isOffline ? Icons.videocam_off : Icons.videocam,
              color: statusColor,
              size: 20,
            ),
          ),
        ),
        title: Text(
          camera.name,
          style: AppTypography.cairoSemiBold(
            fontSize: 12.5,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor,
                boxShadow: isOffline
                    ? []
                    : [
                        BoxShadow(
                          color: statusColor.withValues(alpha: 0.8),
                          blurRadius: 4,
                        )
                      ],
              ),
            ),
            const SizedBox(width: 6),
            Text(
              statusText,
              style: AppTypography.cairoRegular(
                fontSize: 10.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_left,
            color: AppColors.textTertiary, size: 20),
      ),
    );
  }
}
