import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/hud_overlay.dart';
import '../../../../core/widgets/ptz_joystick.dart';
import '../../../surveillance_system/domain/entities/app_tab.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';
import '../../../surveillance_system/presentation/controllers/telemetry_notifier.dart';
import '../widgets/quick_actions_dock.dart';
import '../widgets/telemetry_header.dart';

/// Screen 3: Live single camera view screen with HUD and PTZ controller.
class LiveSingleViewScreen extends StatelessWidget {
  const LiveSingleViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isEmergency =
        context.select<AegisProvider, bool>((p) => p.isEmergency);

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

          // HUD Night Vision Layer subscribing efficiently to telemetry
          Positioned.fill(
            child: Selector<TelemetryNotifier, String>(
              selector: (_, t) => t.telemetryFormatted,
              builder: (context, telemetryStr, child) {
                return HudOverlayWidget(
                  cameraName: 'CAM-14',
                  telemetryText: telemetryStr,
                  isEmergency: isEmergency,
                );
              },
            ),
          ),

          // Top Header Overlay inside video
          const Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: TelemetryHeader(),
          ),

          // Concentric PTZ Joystick Control (Bottom Right)
          Positioned(
            right: 20,
            bottom: 30,
            child: PtzJoystickWidget(
              isEmergency: isEmergency,
              onPanTilt: (panDelta, tiltDelta) {
                context.read<TelemetryNotifier>().updatePtz(
                      panDelta: panDelta,
                      tiltDelta: tiltDelta,
                    );
              },
              onZoomIn: () {
                context.read<TelemetryNotifier>().updatePtz(zoomDelta: 0.5);
              },
            ),
          ),

          // Floating Quick Actions Dock (Bottom Left)
          const Positioned(
            left: 20,
            bottom: 30,
            child: QuickActionsDock(),
          ),

          // Swipe Up Hint
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => context
                    .read<AegisProvider>()
                    .setSelectedTab(AppTab.archive),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.keyboard_arrow_up,
                        color: AppColors.textTertiary, size: 16),
                    Text(
                      AppStrings.swipeUpArchiveHint,
                      style: AppTypography.cairoRegular(
                        fontSize: 9.5,
                        color: AppColors.textTertiary,
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
}
