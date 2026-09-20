import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';

/// CamGuard Signature PTZ Directional Controller & Presets Unit.
/// Faithful recreation of the CamGuard CCTV PTZ console (from IMG_8102.PNG).
class CamGuardPtzController extends StatefulWidget {
  final Function(double panDelta, double tiltDelta) onPanTilt;
  final Function(double zoomDelta) onZoom;
  final VoidCallback onResetCenter;
  final bool isEmergency;

  const CamGuardPtzController({
    super.key,
    required this.onPanTilt,
    required this.onZoom,
    required this.onResetCenter,
    this.isEmergency = false,
  });

  @override
  State<CamGuardPtzController> createState() => _CamGuardPtzControllerState();
}

class _CamGuardPtzControllerState extends State<CamGuardPtzController> {
  String? _activeDirection;
  int _selectedPresetIndex = 0;
  final List<String> _presets = ['المدخل الرئيسي', 'منطقة الاستقبال', 'الممر الأوسط', 'المخزن الخلفي'];

  void _pressDirection(String dir, double pan, double tilt) {
    HapticFeedback.mediumImpact();
    setState(() => _activeDirection = dir);
    widget.onPanTilt(pan, tilt);
  }

  void _releaseDirection() {
    setState(() => _activeDirection = null);
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.isEmergency ? AppPalette.crimsonAlert : AppPalette.camGuardBlue;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Presets Chips Selector ──────────────────────────────────────────
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(_presets.length, (index) {
              final isSelected = _selectedPresetIndex == index;
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedPresetIndex = index);
                    // Move camera to simulated preset
                    widget.onPanTilt(index * 15.0 - 20.0, index * 5.0);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppPalette.camGuardBlue
                          : AppPalette.surfaceDark.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.08),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppPalette.camGuardBlue.withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.my_location_rounded,
                          size: 13,
                          color: isSelected ? Colors.white : AppPalette.textLightMuted,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _presets[index],
                          style: AppTypography.cairoBold(
                            fontSize: 11,
                            color: isSelected ? Colors.white : AppPalette.textLightSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 18),

        // ── Main PTZ Console with Zoom Controls on Side ────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Zoom Out Button Pill
            _PtzZoomPill(
              icon: Icons.remove_rounded,
              label: 'تصغير',
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onZoom(-0.5);
              },
            ),
            const SizedBox(width: 20),

            // ── The Circular CamGuard D-Pad Disc ───────────────────────────
            Container(
              width: 175,
              height: 175,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [
                    Color(0xFF1B2338),
                    Color(0xFF111726),
                    Color(0xFF0C101A),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.12),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Direction Arrow: UP
                  Positioned(
                    top: 10,
                    child: _DirectionArrowButton(
                      direction: 'UP',
                      icon: Icons.keyboard_arrow_up_rounded,
                      isActive: _activeDirection == 'UP',
                      accentColor: accentColor,
                      onTapDown: () => _pressDirection('UP', 0.0, 5.0),
                      onTapUp: _releaseDirection,
                    ),
                  ),

                  // Direction Arrow: DOWN
                  Positioned(
                    bottom: 10,
                    child: _DirectionArrowButton(
                      direction: 'DOWN',
                      icon: Icons.keyboard_arrow_down_rounded,
                      isActive: _activeDirection == 'DOWN',
                      accentColor: accentColor,
                      onTapDown: () => _pressDirection('DOWN', 0.0, -5.0),
                      onTapUp: _releaseDirection,
                    ),
                  ),

                  // Direction Arrow: LEFT (Pan Left)
                  Positioned(
                    left: 10,
                    child: _DirectionArrowButton(
                      direction: 'LEFT',
                      icon: Icons.keyboard_arrow_left_rounded,
                      isActive: _activeDirection == 'LEFT',
                      accentColor: accentColor,
                      onTapDown: () => _pressDirection('LEFT', -5.0, 0.0),
                      onTapUp: _releaseDirection,
                    ),
                  ),

                  // Direction Arrow: RIGHT (Pan Right)
                  Positioned(
                    right: 10,
                    child: _DirectionArrowButton(
                      direction: 'RIGHT',
                      icon: Icons.keyboard_arrow_right_rounded,
                      isActive: _activeDirection == 'RIGHT',
                      accentColor: accentColor,
                      onTapDown: () => _pressDirection('RIGHT', 5.0, 0.0),
                      onTapUp: _releaseDirection,
                    ),
                  ),

                  // Center Reset / Calibrate Jewel Orb
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      widget.onResetCenter();
                    },
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppPalette.camGuardGradient,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppPalette.camGuardBlue.withValues(alpha: 0.45),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.restart_alt_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 20),

            // Zoom In Button Pill
            _PtzZoomPill(
              icon: Icons.add_rounded,
              label: 'تكبير',
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onZoom(0.5);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _DirectionArrowButton extends StatelessWidget {
  final String direction;
  final IconData icon;
  final bool isActive;
  final Color accentColor;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;

  const _DirectionArrowButton({
    required this.direction,
    required this.icon,
    required this.isActive,
    required this.accentColor,
    required this.onTapDown,
    required this.onTapUp,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: onTapUp,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? accentColor.withValues(alpha: 0.35)
              : Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: isActive ? accentColor : Colors.white.withValues(alpha: 0.1),
            width: 1.2,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.4),
                    blurRadius: 8,
                  )
                ]
              : null,
        ),
        child: Center(
          child: Icon(
            icon,
            size: 26,
            color: isActive ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }
}

class _PtzZoomPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PtzZoomPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppPalette.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppPalette.camGuardBlue, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.cairoBold(
                fontSize: 10.5,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
