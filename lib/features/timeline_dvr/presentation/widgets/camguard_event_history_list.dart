import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/feedback/cctv_state_view.dart';

/// Data model for historical surveillance video clip event.
class CamGuardEventItem {
  final String id;
  final String title;
  final String cameraName;
  final String timeText;
  final String duration;
  final double playheadPosition;
  final IconData icon;
  final Color badgeColor;

  const CamGuardEventItem({
    required this.id,
    required this.title,
    required this.cameraName,
    required this.timeText,
    required this.duration,
    required this.playheadPosition,
    required this.icon,
    required this.badgeColor,
  });
}

/// CamGuard Event History List widget (from IMG_8102.PNG Playback & Event History).
class CamGuardEventHistoryList extends StatelessWidget {
  final Function(double playhead) onSelectEvent;
  final List<CamGuardEventItem>? events;

  const CamGuardEventHistoryList({
    super.key,
    required this.onSelectEvent,
    this.events,
  });

  static const List<CamGuardEventItem> _mockEvents = [
    CamGuardEventItem(
      id: 'ev-1',
      title: 'رصد حركة شخص مشبوه',
      cameraName: 'CAM-01 • المدخل الرئيسي',
      timeText: '11:42:10 ص',
      duration: '00:35',
      playheadPosition: 0.25,
      icon: Icons.person_search_rounded,
      badgeColor: AppPalette.amberWarning,
    ),
    CamGuardEventItem(
      id: 'ev-2',
      title: 'دخول مركبة شحن للموقع',
      cameraName: 'CAM-04 • بوابة الشاحنات',
      timeText: '10:15:22 ص',
      duration: '01:12',
      playheadPosition: 0.45,
      icon: Icons.local_shipping_rounded,
      badgeColor: AppPalette.camGuardBlue,
    ),
    CamGuardEventItem(
      id: 'ev-3',
      title: 'نشاط مستشعر الباب الخلفي',
      cameraName: 'CAM-03 • مستودع المواد',
      timeText: '08:50:00 ص',
      duration: '00:20',
      playheadPosition: 0.70,
      icon: Icons.sensor_door_rounded,
      badgeColor: AppPalette.royalViolet,
    ),
    CamGuardEventItem(
      id: 'ev-4',
      title: 'تسجيل دوري مجدول',
      cameraName: 'CAM-02 • صالة الموظفين',
      timeText: '07:30:15 ص',
      duration: '02:00',
      playheadPosition: 0.88,
      icon: Icons.videocam_rounded,
      badgeColor: AppPalette.emeraldLive,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final items = events ?? _mockEvents;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 15,
                    decoration: BoxDecoration(
                      color: AppPalette.camGuardBlue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'سجل الأحداث والحركات المسجلة',
                    style: AppTypography.cairoBold(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppPalette.camGuardBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${items.length} أحداث',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppPalette.cyanLight,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        if (items.isEmpty)
          CctvStateView.emptyEvents()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final ev = items[index];
              return _EventCardTile(
                event: ev,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onSelectEvent(ev.playheadPosition);
                },
              );
            },
          ),
      ],
    );
  }
}

class _EventCardTile extends StatelessWidget {
  final CamGuardEventItem event;
  final VoidCallback onTap;

  const _EventCardTile({
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppPalette.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail preview simulation box
            Container(
              width: 60,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF0F1524),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: event.badgeColor.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(event.icon, size: 22, color: event.badgeColor),
                  Positioned(
                    bottom: 2,
                    right: 4,
                    child: Text(
                      event.duration,
                      style: const TextStyle(
                        fontSize: 8.5,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Event Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.cairoBold(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.cameraName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.cairoRegular(
                      fontSize: 10,
                      color: AppPalette.textLightMuted,
                    ),
                  ),
                ],
              ),
            ),

            // Time & Play action pill
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  event.timeText,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppPalette.cyanLight,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppPalette.camGuardBlue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow_rounded, size: 12, color: Colors.white),
                      SizedBox(width: 2),
                      Text(
                        'تشغيل',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
