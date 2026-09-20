import 'package:flutter/material.dart';
import '../../theme/app_palette.dart';
import '../../theme/app_typography.dart';
import '../royal/royal_button.dart';

enum CctvStateType { empty, offline, error, permissionDenied }

/// Comprehensive state view for empty results, offline feeds, connection errors, and RBAC restrictions.
class CctvStateView extends StatelessWidget {
  final CctvStateType type;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const CctvStateView({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  factory CctvStateView.emptyCameras({VoidCallback? onAddCamera}) {
    return CctvStateView(
      type: CctvStateType.empty,
      title: 'لا توجد كاميرات في هذه المنطقة',
      message: 'لم يتم ربط أي كاميرا بهذا الموقع بعد. يمكنك ربط جهاز NVR أو إضافة كاميرا جديدة.',
      actionLabel: onAddCamera != null ? 'ربط كاميرا الآن' : null,
      onAction: onAddCamera,
    );
  }

  factory CctvStateView.emptyEvents({String? date}) {
    return CctvStateView(
      type: CctvStateType.empty,
      title: 'لا توجد أحداث مسجلة',
      message: date != null
          ? 'لم يتم تسجيل أي تنبيهات أو حركات في تاريخ $date.'
          : 'سجل الأحداث نظيف، لم يتم رصد أي أنشطة مشبوهة.',
    );
  }

  factory CctvStateView.streamOffline({required VoidCallback onRetry}) {
    return CctvStateView(
      type: CctvStateType.offline,
      title: 'انقطع الاتصال بالبث المباشر',
      message: 'تعذر الاتصال بعنوان الـ RTSP. يرجى التأكد من تشغيل الـ NVR واتصال الشبكة المحلية.',
      actionLabel: 'إعادة الاتصال',
      onAction: onRetry,
    );
  }

  factory CctvStateView.permissionDenied({String? roleName}) {
    return CctvStateView(
      type: CctvStateType.permissionDenied,
      title: 'ليس لديك صلاحية وصول',
      message: roleName != null
          ? 'حسابك الحالي ($roleName) لا يملك صلاحية التحكم في هذا القسم. يرجى مراجعة مسؤول المنظومة.'
          : 'لا تملك الصلاحيات الكافية للوصول إلى هذا القسم.',
    );
  }

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;
    switch (type) {
      case CctvStateType.empty:
        icon = Icons.videocam_off_outlined;
        iconColor = AppPalette.primary;
        break;
      case CctvStateType.offline:
        icon = Icons.wifi_off_rounded;
        iconColor = AppPalette.amberWarning;
        break;
      case CctvStateType.error:
        icon = Icons.error_outline_rounded;
        iconColor = AppPalette.crimsonAlert;
        break;
      case CctvStateType.permissionDenied:
        icon = Icons.lock_outline_rounded;
        iconColor = AppPalette.coral;
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: iconColor.withValues(alpha: 0.35)),
              ),
              child: Icon(icon, size: 34, color: iconColor),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.cairoBold(fontSize: 15, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.cairoRegular(
                fontSize: 12,
                color: AppPalette.textLightMuted,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              RoyalButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: RoyalButtonVariant.primary,
                height: 42,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
