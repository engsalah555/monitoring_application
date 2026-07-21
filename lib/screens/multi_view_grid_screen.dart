import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/camera_model.dart';
import '../state/aegis_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/hud_overlay.dart';

/// Screen 4: Multi view camera grid screen (4 vs 8 grid modes).
class MultiViewGridScreen extends StatelessWidget {
  const MultiViewGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AegisProvider>(context);
    final primaryColor = AppColors.getPrimary(provider.isEmergency);

    final isFourGrid = provider.gridCount == 4;

    return Column(
      children: [
        // Multi view Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المنطقة ب · البث المتعدد',
                style: GoogleFonts.cairo(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Layout segment selector (4 cameras vs 8 cameras)
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.panel,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.panelLine),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => provider.setGridCount(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isFourGrid
                              ? AppColors.panelRaised
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '٤ كاميرات',
                          style: GoogleFonts.cairo(
                            color: isFourGrid
                                ? primaryColor
                                : AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => provider.setGridCount(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: !isFourGrid
                              ? AppColors.panelRaised
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '٨ كاميرات',
                          style: GoogleFonts.cairo(
                            color: !isFourGrid
                                ? primaryColor
                                : AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Camera Grid View
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: isFourGrid ? 1.2 : 1.5,
              children: [
                _buildTile(
                  context: context,
                  camName: 'كاميرا ١٤',
                  isLive: true,
                ),
                _buildTile(
                  context: context,
                  camName: 'كاميرا ١٥',
                  isLive: true,
                ),
                _buildTile(
                  context: context,
                  camName: 'كاميرا ١٦',
                  isOffline: true,
                ),
                _buildTile(
                  context: context,
                  camName: 'كاميرا ١٧',
                  isAlert: true,
                ),
                if (!isFourGrid) ...[
                  _buildTile(
                    context: context,
                    camName: 'كاميرا ١٨',
                    isLive: true,
                  ),
                  _buildTile(
                    context: context,
                    camName: 'كاميرا ١٩',
                    isLive: true,
                  ),
                  _buildTile(
                    context: context,
                    camName: 'كاميرا ٢٠',
                    isLive: true,
                  ),
                  _buildTile(
                    context: context,
                    camName: 'كاميرا ٢١',
                    isLive: true,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTile({
    required BuildContext context,
    required String camName,
    bool isLive = false,
    bool isOffline = false,
    bool isAlert = false,
  }) {
    final provider = Provider.of<AegisProvider>(context);
    final primaryColor = AppColors.getPrimary(provider.isEmergency);

    final statusColor = isOffline
        ? AppColors.textTertiary
        : (isAlert
            ? (provider.isEmergency ? AppColors.red : AppColors.amber)
            : primaryColor);

    return GestureDetector(
      onTap: () {
        provider.setSelectedTab(AppTab.liveSingle);
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
                isEmergency: provider.isEmergency,
              ),
            ),
            // Tag Header inside tile
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.bgPage.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
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
                      style: GoogleFonts.cairo(
                        color: AppColors.textPrimary,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
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
