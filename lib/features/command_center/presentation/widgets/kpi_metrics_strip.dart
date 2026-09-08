import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/neumorphic_decorations.dart';

/// KPI Executive Metrics Strip Widget displaying live operational stats.
class KpiMetricsStrip extends StatelessWidget {
  const KpiMetricsStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final metrics = [
      (
        label: 'الكاميرات الحية',
        value: '12 / 12',
        sub: '100% اونلاين',
        icon: Icons.videocam_rounded,
        color: AppColors.green,
      ),
      (
        label: 'التنبيهات والذكاء',
        value: '3 تنبيهات',
        sub: 'كشف حركة وسيارات',
        icon: Icons.auto_awesome_rounded,
        color: AppColors.amber,
      ),
      (
        label: 'التخزين والمساحة',
        value: '94% متاح',
        sub: 'NVR 4TB Cloud',
        icon: Icons.cloud_done_rounded,
        color: AppColors.primaryBlue,
      ),
      (
        label: 'سرعة وسلاسة البث',
        value: '60 FPS',
        sub: '4K Ultra HD',
        icon: Icons.speed_rounded,
        color: AppColors.cyan,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: metrics.map((m) {
          return Container(
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            constraints: const BoxConstraints(minWidth: 140),
            decoration: NeumorphicDecorations.softRaised(
              color: AppColors.clayCard,
              borderRadius: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(m.icon, size: 16, color: m.color),
                    const SizedBox(width: 6),
                    Text(
                      m.label,
                      style: AppTypography.cairoBold(
                        fontSize: 10.5,
                        color: AppColors.textDarkSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  m.value,
                  style: AppTypography.cairoBold(
                    fontSize: 14,
                    color: AppColors.textDarkPrimary,
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
          );
        }).toList(),
      ),
    );
  }
}
