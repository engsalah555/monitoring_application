import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/camera_model.dart';
import '../state/aegis_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/hud_overlay.dart';
import '../widgets/ptz_joystick.dart';

/// Screen 3: Live single camera view screen with HUD and PTZ controller.
class LiveSingleViewScreen extends StatelessWidget {
  const LiveSingleViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AegisProvider>(context);
    final primaryColor = AppColors.getPrimary(provider.isEmergency);

    final telemetryStr =
        'PAN: ${provider.pan.toStringAsFixed(1)}° | TILT: ${provider.tilt.toStringAsFixed(1)}° | ZM: ${provider.zoom.toStringAsFixed(1)}x';

    return Container(
      color: AppColors.bgVoid,
      child: Stack(
        children: [
          // Background Feed Simulation Container
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [
                    AppColors.panelRaised.withValues(alpha: 0.4),
                    AppColors.bgVoid,
                  ],
                ),
              ),
            ),
          ),

          // HUD Night Vision Layer
          Positioned.fill(
            child: HudOverlayWidget(
              cameraName: 'CAM-14',
              telemetryText: telemetryStr,
              isEmergency: provider.isEmergency,
            ),
          ),

          // Top Header Overlay inside video
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مول وسط المدينة / الطابق ٢ / المنطقة ب',
                      style: GoogleFonts.cairo(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
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
                          provider.isEmergency
                              ? 'كاميرا ١٤ · طوارئ'
                              : 'كاميرا ١٤ · مباشر',
                          style: GoogleFonts.cairo(
                            color: primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '١٣ يوليو ٢٠٢٦\n${provider.timeFormatted}',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.ibmPlexMono(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Concentric PTZ Joystick Control (Bottom Right)
          Positioned(
            right: 20,
            bottom: 30,
            child: PtzJoystickWidget(
              isEmergency: provider.isEmergency,
              onPanTilt: (panDelta, tiltDelta) {
                provider.updatePtz(panDelta: panDelta, tiltDelta: tiltDelta);
              },
              onZoomIn: () {
                provider.updatePtz(zoomDelta: 0.5);
              },
            ),
          ),

          // Floating Quick Actions Dock (Bottom Left)
          Positioned(
            left: 20,
            bottom: 30,
            child: Column(
              children: [
                _buildDockBtn(
                  icon: Icons.camera_alt_outlined,
                  color: AppColors.textPrimary,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'تم التقاط لقطة الشاشة وتخزينها',
                          style: GoogleFonts.cairo(),
                        ),
                        backgroundColor: AppColors.panelRaised,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDockBtn(
                  icon: Icons.fiber_manual_record,
                  color: AppColors.red,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'جاري تسجيل الحدث المباشر...',
                          style: GoogleFonts.cairo(),
                        ),
                        backgroundColor: AppColors.red,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDockBtn(
                  icon: Icons.share_outlined,
                  color: AppColors.textPrimary,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'تم مشاركة الرابط التصعيدي للحدَث',
                          style: GoogleFonts.cairo(),
                        ),
                        backgroundColor: AppColors.panelRaised,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Swipe Up Hint
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => provider.setSelectedTab(AppTab.archive),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.keyboard_arrow_up,
                        color: AppColors.textTertiary, size: 16),
                    Text(
                      'اسحب للأعلى لتصفح الأرشيف',
                      style: GoogleFonts.cairo(
                        color: AppColors.textTertiary,
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDockBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.panel.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.panelLine),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 20),
        onPressed: onTap,
      ),
    );
  }
}
