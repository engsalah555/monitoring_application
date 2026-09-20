import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/hud_overlay.dart';
import '../../../surveillance_system/domain/entities/app_tab.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';
import '../../../surveillance_system/presentation/controllers/telemetry_notifier.dart';
import '../widgets/camguard_action_toolbar.dart';
import '../widgets/camguard_ptz_controller.dart';

/// Screen 3: CamGuard Dedicated Live Camera View Screen with PTZ Controls and Stream Tools.
class LiveSingleViewScreen extends StatefulWidget {
  const LiveSingleViewScreen({super.key});

  @override
  State<LiveSingleViewScreen> createState() => _LiveSingleViewScreenState();
}

class _LiveSingleViewScreenState extends State<LiveSingleViewScreen> {
  bool _isFlashing = false;
  bool _isRecording = false;
  bool _isNightVision = false;
  String _selectedResolution = '1080P FHD';

  void _handleSnapshot() {
    setState(() => _isFlashing = true);
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) setState(() => _isFlashing = false);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppPalette.emeraldLive, size: 20),
            SizedBox(width: 8),
            Text('تم التقاط لقطة شاشة عالية الدقة وحفظها بأمان'),
          ],
        ),
        duration: Duration(seconds: 2),
        backgroundColor: AppPalette.surfaceDark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleSiren() {
    final aegis = context.read<AegisProvider>();
    aegis.toggleEmergencyMode();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          aegis.isEmergency ? 'تم إطلاق صفارة الإنذار وتفعيل وضع الطوارئ!' : 'تم إيقاف الإنذار',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: aegis.isEmergency ? AppPalette.crimsonAlert : AppPalette.surfaceDark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEmergency = context.select<AegisProvider, bool>((p) => p.isEmergency);

    return Scaffold(
      backgroundColor: AppPalette.bgDarkObsidian,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 1. Top Camera Header Bar ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppPalette.emeraldLive,
                            boxShadow: [
                              BoxShadow(
                                color: AppPalette.emeraldLive,
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'CAM-01 • المدخل الرئيسي',
                          style: AppTypography.cairoBold(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    // Resolution Switcher Pill (1080P / 4K / Auto)
                    PopupMenuButton<String>(
                      initialValue: _selectedResolution,
                      onSelected: (val) {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedResolution = val);
                      },
                      color: AppPalette.surfaceDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.white24),
                      ),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: '1080P FHD', child: Text('1080P FHD', style: TextStyle(color: Colors.white))),
                        const PopupMenuItem(value: '4K Ultra HD', child: Text('4K Ultra HD', style: TextStyle(color: Colors.white))),
                        const PopupMenuItem(value: '720P HD (توفير)', child: Text('720P HD (توفير)', style: TextStyle(color: Colors.white70))),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppPalette.surfaceDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppPalette.camGuardBlue.withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedResolution,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppPalette.cyanLight,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_drop_down, color: AppPalette.cyanLight, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── 2. Video Viewport Surface with Overlays ──────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: AspectRatio(
                  aspectRatio: 16 / 9.5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C101A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isEmergency ? AppPalette.crimsonAlert : AppPalette.camGuardBlue.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isEmergency
                              ? AppPalette.crimsonAlert.withValues(alpha: 0.3)
                              : AppPalette.camGuardBlue.withValues(alpha: 0.15),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        children: [
                          // Background Video Feed Simulation
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  center: Alignment.center,
                                  radius: 0.85,
                                  colors: [
                                    _isNightVision ? const Color(0xFF15222E) : const Color(0xFF141E33),
                                    const Color(0xFF090D17),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // HUD Night Vision Layer subscribing to Telemetry
                          Positioned.fill(
                            child: Selector<TelemetryNotifier, String>(
                              selector: (_, t) => t.telemetryFormatted,
                              builder: (context, telemetryStr, child) {
                                return HudOverlayWidget(
                                  cameraName: 'CAM-01 • MAIN GATE',
                                  telemetryText: telemetryStr,
                                  isEmergency: isEmergency,
                                );
                              },
                            ),
                          ),

                          // Recording Indicator if active
                          if (_isRecording)
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppPalette.crimsonAlert,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.circle, color: Colors.white, size: 8),
                                    SizedBox(width: 4),
                                    Text(
                                      'REC',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // Snapshot Flash effect
                          if (_isFlashing)
                            Positioned.fill(
                              child: Container(color: Colors.white.withValues(alpha: 0.7)),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── 3. CamGuard Stream Action Toolbar ────────────────────────
              CamGuardActionToolbar(
                onSnapshot: _handleSnapshot,
                onRecordingChanged: (rec) => setState(() => _isRecording = rec),
                onNightVisionChanged: (nv) => setState(() => _isNightVision = nv),
                onTriggerSiren: _handleSiren,
              ),

              const SizedBox(height: 6),

              // ── 4. CamGuard Signature PTZ Directional Controller ─────────
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CamGuardPtzController(
                  isEmergency: isEmergency,
                  onPanTilt: (panDelta, tiltDelta) {
                    context.read<TelemetryNotifier>().updatePtz(
                          panDelta: panDelta,
                          tiltDelta: tiltDelta,
                        );
                  },
                  onZoom: (zoomDelta) {
                    context.read<TelemetryNotifier>().updatePtz(zoomDelta: zoomDelta);
                  },
                  onResetCenter: () {
                    context.read<TelemetryNotifier>().updatePtz(panDelta: 0, tiltDelta: 0);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تمت إعادة ضبط زاوية الكاميرا للمركز الافتراضي'),
                        duration: Duration(milliseconds: 1500),
                        backgroundColor: AppPalette.surfaceDark,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),

              // ── 5. Quick Shortcut to Playback History ────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      context.read<AegisProvider>().setSelectedTab(AppTab.archive);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.history_rounded, color: AppPalette.camGuardBlue, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'الانتقال إلى سجل التسجيلات والخط الزمني لهذه الكاميرا',
                            style: AppTypography.cairoBold(
                              fontSize: 11.5,
                              color: AppPalette.camGuardBlue,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_left_rounded, color: AppPalette.camGuardBlue, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 90), // Spacing for floating dock
            ],
          ),
        ),
      ),
    );
  }
}
