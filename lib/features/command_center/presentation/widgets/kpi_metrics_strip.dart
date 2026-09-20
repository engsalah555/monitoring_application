import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';

/// KPI Executive Metrics Strip Widget displaying live operational stats with virtualized scrolling.
class KpiMetricsStrip extends StatelessWidget {
  const KpiMetricsStrip({super.key});

  static const _metrics = [
    (
      label: 'الكاميرات الحية',
      value: '12 / 12',
      sub: '100% متصل بالشبكة',
      icon: Icons.videocam_rounded,
      color: AppPalette.emeraldLive,
      glow: AppPalette.emeraldGlow,
    ),
    (
      label: 'التنبيهات والذكاء',
      value: '3 تنبيهات',
      sub: 'كشف حركة وسيارات',
      icon: Icons.auto_awesome_rounded,
      color: AppPalette.amberWarning,
      glow: AppPalette.amberGlow,
    ),
    (
      label: 'التخزين والمساحة',
      value: '94% متاح',
      sub: 'NVR 4TB Cloud',
      icon: Icons.cloud_done_rounded,
      color: AppPalette.cyanLight,
      glow: AppPalette.cyanGlow,
    ),
    (
      label: 'سرعة وسلاسة البث',
      value: '60 FPS',
      sub: '4K Ultra HD',
      icon: Icons.speed_rounded,
      color: AppPalette.imperialGold,
      glow: AppPalette.goldGlow,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 106,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _metrics.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final m = _metrics[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppPalette.surfaceDark,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: m.color.withValues(alpha: 0.25),
                width: 1,
              ),
              boxShadow: AppPalette.softCardShadow,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 135),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: m.glow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(m.icon, size: 15, color: m.color),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        m.label,
                        style: AppTypography.cairoBold(
                          fontSize: 10.5,
                          color: AppPalette.textLightSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    m.value,
                    style: AppTypography.cairoBold(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    m.sub,
                    style: AppTypography.cairoRegular(
                      fontSize: 9.5,
                      color: m.color,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
