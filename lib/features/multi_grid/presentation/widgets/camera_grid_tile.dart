import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/hud_overlay.dart';
import '../../../surveillance_system/domain/entities/app_tab.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';

/// Reusable Camera Grid Tile Widget for MultiView Grid.
class CameraGridTile extends StatelessWidget {
  final String camName;
  final bool isLive;
  final bool isOffline;
  final bool isAlert;

  const CameraGridTile({
    super.key,
    required this.camName,
    this.isLive = false,
    this.isOffline = false,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEmergency =
        context.select<AegisProvider, bool>((p) => p.isEmergency);
    final primaryColor = AppColors.getPrimary(isEmergency);

    final statusColor = isOffline
        ? AppColors.textTertiary
        : (isAlert
            ? (isEmergency ? AppColors.red : AppColors.amber)
            : primaryColor);

    return GestureDetector(
      onTap: () {
        context.read<AegisProvider>().setSelectedTab(AppTab.liveSingle);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.panel,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.panelLine),
        ),
        child: Stack(
          children: [
            // HUD Overlay inside tile
            Positioned.fill(
              child: HudOverlayWidget(
                cameraName: camName,
                telemetryText: '60 FPS',
                isOffline: isOffline,
                isEmergency: isEmergency,
              ),
            ),
            // Tag Header inside tile
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.bgPage.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(6),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5.5,
                      height: 5.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      camName,
                      style: AppTypography.cairoBold(
                        fontSize: 9,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
