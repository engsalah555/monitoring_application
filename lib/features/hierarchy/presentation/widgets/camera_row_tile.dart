import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/layout/executive_list_tile.dart';
import '../../../surveillance_system/domain/entities/camera_node.dart';
import '../../../surveillance_system/domain/entities/camera_status.dart';

/// Standardized Camera List Row Tile Widget built on ExecutiveListTile.
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
        ? AppPalette.textLightMuted
        : (isAlert
            ? (isEmergency ? AppPalette.crimsonAlert : AppPalette.amberWarning)
            : AppPalette.primary);

    final statusText = isOffline
        ? 'غير متصل · منذ ساعتين'
        : (isAlert
            ? (isEmergency ? 'اختراق أمني · كشف حركة' : 'تنبيه حركة')
            : 'بث مباشر · بدقة ${camera.resolution}');

    return ExecutiveListTile(
      title: camera.name,
      onTap: onTap,
      leading: Container(
        width: 48,
        height: 42,
        decoration: BoxDecoration(
          color: isOffline
              ? AppPalette.surfaceDark
              : statusColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isOffline
                ? AppPalette.borderDark
                : statusColor.withValues(alpha: 0.35),
          ),
        ),
        child: Center(
          child: Icon(
            isOffline
                ? Icons.videocam_off_rounded
                : Icons.videocam_rounded,
            color: statusColor,
            size: 20,
          ),
        ),
      ),
      subtitle: statusText,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withValues(alpha: 0.6),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_left_rounded,
            color: AppPalette.textLightMuted,
            size: 18,
          ),
        ],
      ),
    );
  }
}
