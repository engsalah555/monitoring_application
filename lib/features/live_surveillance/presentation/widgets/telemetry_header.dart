import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';
import '../../../surveillance_system/presentation/controllers/telemetry_notifier.dart';

/// Top Header Telemetry Overlay Widget for Live Single Camera View.
class TelemetryHeader extends StatelessWidget {
  const TelemetryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isEmergency =
        context.select<AegisProvider, bool>((p) => p.isEmergency);
    final primaryColor = AppColors.getPrimary(isEmergency);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.camLocationHeader,
              style: AppTypography.cairoSemiBold(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor,
                        blurRadius: 6,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isEmergency
                      ? AppStrings.camEmergencyTag
                      : AppStrings.camLiveTag,
                  style: AppTypography.cairoBold(
                    fontSize: 11,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        Selector<TelemetryNotifier, String>(
          selector: (_, t) => t.timeFormatted,
          builder: (context, timeStr, child) {
            return Text(
              '١٣ يوليو ٢٠٢٦\n$timeStr',
              textAlign: TextAlign.left,
              style: AppTypography.monoRegular(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            );
          },
        ),
      ],
    );
  }
}
