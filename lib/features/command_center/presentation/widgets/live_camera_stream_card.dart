import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/royal/royal_badge.dart';
import '../../../surveillance_system/domain/entities/camera_node.dart';
import '../../../surveillance_system/domain/entities/camera_status.dart';

/// Luxury Realistic Live Camera Stream Preview Card.
/// Simulates an authentic high-resolution CCTV live feed with real-time HUD overlays.
class LiveCameraStreamCard extends StatefulWidget {
  final CameraNode camera;
  final bool isEmergency;
  final VoidCallback onTap;

  const LiveCameraStreamCard({
    super.key,
    required this.camera,
    this.isEmergency = false,
    required this.onTap,
  });

  @override
  State<LiveCameraStreamCard> createState() => _LiveCameraStreamCardState();
}

class _LiveCameraStreamCardState extends State<LiveCameraStreamCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isMuted = true;
  bool _isFlashing = false;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _triggerSnapshot() {
    HapticFeedback.mediumImpact();
    setState(() => _isFlashing = true);
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) setState(() => _isFlashing = false);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم التقاط صورة من ${widget.camera.name} وحفظها في المعرض'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppPalette.surfaceDark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAlert = widget.camera.status == CameraStatus.alert || widget.isEmergency;
    final accentColor = isAlert ? AppPalette.crimsonAlert : AppPalette.camGuardBlue;
    final borderColor = isAlert
        ? AppPalette.crimsonAlert.withValues(alpha: 0.7)
        : (_isHovered
            ? AppPalette.camGuardBlue
            : AppPalette.camGuardBlue.withValues(alpha: 0.3));

    return AnimatedScale(
      scale: _isHovered ? 1.025 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap();
        },
        onHighlightChanged: (val) => setState(() => _isHovered = val),
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 255,
          height: 165,
          decoration: BoxDecoration(
            color: AppPalette.cardDark,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor, width: _isHovered ? 1.8 : 1.2),
            boxShadow: [
              BoxShadow(
                color: isAlert
                    ? AppPalette.crimsonAlert.withValues(alpha: 0.3)
                    : AppPalette.camGuardBlue.withValues(alpha: _isHovered ? 0.3 : 0.12),
                blurRadius: _isHovered ? 20 : 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(21),
            child: Stack(
              children: [
                // 1. Simulated Live Video Surface Backdrop
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF141C2E),
                          Color(0xFF0F1524),
                          Color(0xFF090D17),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // 2. CCTV Optics HUD Reticle Simulation
                Positioned.fill(
                  child: CustomPaint(
                    painter: _CctvHudPainter(accentColor: accentColor),
                  ),
                ),

                // 3. Top HUD Status Bar (CamGuard Style Badges)
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Status Badge (LIVE / MOTION ALERT) with breathing pulse
                      Flexible(
                        child: isAlert
                            ? const RoyalStatusBadge(
                                label: 'تنبيه حركة',
                                color: AppPalette.crimsonAlert,
                                icon: Icons.warning_amber_rounded,
                                isLivePulsing: true,
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppPalette.emeraldLive.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FadeTransition(
                                      opacity: _pulseAnimation,
                                      child: Container(
                                        width: 7,
                                        height: 7,
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
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      'مباشر • LIVE',
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(width: 8),

                      // Resolution & Signal Badge
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                            decoration: BoxDecoration(
                              color: AppPalette.camGuardBlue.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppPalette.camGuardBlue.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              widget.camera.resolution,
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF60A5FA),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 4. Center Play / Fullscreen Reticle Action
                Center(
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppPalette.camGuardBlue.withValues(alpha: 0.8),
                          AppPalette.primaryDark.withValues(alpha: 0.9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppPalette.camGuardBlue.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),

                // 5. Quick Action Overlay Buttons (CamGuard Snapshot & Audio)
                Positioned(
                  right: 8,
                  top: 48,
                  child: Column(
                    children: [
                      // Audio Mute/Unmute
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _isMuted = !_isMuted);
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.6),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Icon(
                            _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                            size: 15,
                            color: _isMuted ? Colors.white60 : AppPalette.camGuardBlue,
                          ),
                        ),
                      ),
                      // Quick Snapshot
                      GestureDetector(
                        onTap: _triggerSnapshot,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.6),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 6. Camera Snapshot Flash simulation
                if (_isFlashing)
                  Positioned.fill(
                    child: Container(
                      color: Colors.white.withValues(alpha: 0.65),
                    ),
                  ),

                // 7. Bottom Frosted Glass Camera Information Bar (CamGuard Style)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xF00A0F1D),
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.camera.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.cairoBold(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.camera.location,
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
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: AppPalette.camGuardGradient,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: AppPalette.camGuardBlue.withValues(alpha: 0.3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.fullscreen_rounded, size: 14, color: Colors.white),
                              const SizedBox(width: 3),
                              Text(
                                'تحكم مباشر',
                                style: AppTypography.cairoBold(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Painter for CCTV optics HUD reticle and corner brackets.
class _CctvHudPainter extends CustomPainter {
  final Color accentColor;

  _CctvHudPainter({required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accentColor.withValues(alpha: 0.2)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Center crosshair tick marks
    final cx = size.width / 2;
    final cy = size.height / 2;
    const len = 8.0;

    canvas.drawLine(Offset(cx - len - 16, cy), Offset(cx - 16, cy), paint);
    canvas.drawLine(Offset(cx + 16, cy), Offset(cx + len + 16, cy), paint);
    canvas.drawLine(Offset(cx, cy - len - 16), Offset(cx, cy - 16), paint);
    canvas.drawLine(Offset(cx, cy + 16), Offset(cx, cy + len + 16), paint);

    // Corner brackets
    const bracketSize = 10.0;
    final cornerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    // Top-left
    canvas.drawLine(const Offset(8, 8), const Offset(8 + bracketSize, 8), cornerPaint);
    canvas.drawLine(const Offset(8, 8), const Offset(8, 8 + bracketSize), cornerPaint);

    // Top-right
    canvas.drawLine(Offset(size.width - 8, 8), Offset(size.width - 8 - bracketSize, 8), cornerPaint);
    canvas.drawLine(Offset(size.width - 8, 8), Offset(size.width - 8, 8 + bracketSize), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant _CctvHudPainter oldDelegate) =>
      oldDelegate.accentColor != accentColor;
}
