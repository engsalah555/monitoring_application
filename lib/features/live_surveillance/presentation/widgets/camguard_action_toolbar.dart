import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';

/// CamGuard Stream Action Toolbar with Snapshot, Record, Intercom, Siren, and Night Vision.
class CamGuardActionToolbar extends StatefulWidget {
  final VoidCallback onSnapshot;
  final ValueChanged<bool> onRecordingChanged;
  final ValueChanged<bool> onNightVisionChanged;
  final VoidCallback onTriggerSiren;

  const CamGuardActionToolbar({
    super.key,
    required this.onSnapshot,
    required this.onRecordingChanged,
    required this.onNightVisionChanged,
    required this.onTriggerSiren,
  });

  @override
  State<CamGuardActionToolbar> createState() => _CamGuardActionToolbarState();
}

class _CamGuardActionToolbarState extends State<CamGuardActionToolbar> {
  bool _isRecording = false;
  bool _isNightVision = false;
  bool _isIntercomActive = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppPalette.surfaceDark.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 1. Snapshot
          _ActionToolItem(
            icon: Icons.camera_alt_rounded,
            label: 'لقطة',
            isActive: false,
            activeColor: AppPalette.camGuardBlue,
            onTap: () {
              HapticFeedback.mediumImpact();
              widget.onSnapshot();
            },
          ),

          // 2. Video Record
          _ActionToolItem(
            icon: _isRecording ? Icons.stop_circle_rounded : Icons.videocam_rounded,
            label: _isRecording ? 'تسجيل...' : 'تسجيل',
            isActive: _isRecording,
            activeColor: AppPalette.crimsonAlert,
            onTap: () {
              HapticFeedback.heavyImpact();
              setState(() => _isRecording = !_isRecording);
              widget.onRecordingChanged(_isRecording);
            },
          ),

          // 3. Microphone (Push to Talk)
          _ActionToolItem(
            icon: _isIntercomActive ? Icons.mic_rounded : Icons.mic_none_rounded,
            label: _isIntercomActive ? 'تحدث...' : 'تحدث',
            isActive: _isIntercomActive,
            activeColor: AppPalette.camGuardBlue,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _isIntercomActive = !_isIntercomActive);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isIntercomActive ? 'الميكروفون نشط: البث الصوتي مفعّل' : 'تم كتم الميكروفون'),
                  duration: const Duration(milliseconds: 1500),
                  backgroundColor: AppPalette.surfaceDark,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),

          // 4. Night Vision Mode
          _ActionToolItem(
            icon: _isNightVision ? Icons.nightlight_round : Icons.wb_sunny_rounded,
            label: 'رؤية ليلية',
            isActive: _isNightVision,
            activeColor: AppPalette.royalViolet,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _isNightVision = !_isNightVision);
              widget.onNightVisionChanged(_isNightVision);
            },
          ),

          // 5. Emergency Siren
          _ActionToolItem(
            icon: Icons.campaign_rounded,
            label: 'إنذار',
            isActive: false,
            activeColor: AppPalette.crimsonAlert,
            onTap: () {
              HapticFeedback.heavyImpact();
              widget.onTriggerSiren();
            },
          ),
        ],
      ),
    );
  }
}

class _ActionToolItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _ActionToolItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? activeColor.withValues(alpha: 0.25)
                  : Colors.white.withValues(alpha: 0.06),
              border: Border.all(
                color: isActive ? activeColor : Colors.white.withValues(alpha: 0.12),
                width: 1.3,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.35),
                        blurRadius: 10,
                      )
                    ]
                  : null,
            ),
            child: Center(
              child: Icon(
                icon,
                size: 22,
                color: isActive ? activeColor : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: AppTypography.cairoRegular(
              fontSize: 10,
              color: isActive ? activeColor : AppPalette.textLightSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
