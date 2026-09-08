import 'package:flutter/material.dart';
import '../../theme/app_palette.dart';
import '../../theme/app_typography.dart';

/// Reusable Royal Status & Alert Badge with subtle live glowing pulse.
class RoyalStatusBadge extends StatefulWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool isLivePulsing;
  final VoidCallback? onTap;

  const RoyalStatusBadge({
    super.key,
    required this.label,
    this.color = AppPalette.emeraldLive,
    this.icon,
    this.isLivePulsing = false,
    this.onTap,
  });

  /// Factory for Online Live status badge
  factory RoyalStatusBadge.live({String label = 'مباشر (LIVE)'}) {
    return RoyalStatusBadge(
      label: label,
      color: AppPalette.emeraldLive,
      isLivePulsing: true,
    );
  }

  /// Factory for Emergency / Alert status badge
  factory RoyalStatusBadge.alert({required int count}) {
    return RoyalStatusBadge(
      label: '$count تنبيهات حرجة',
      color: AppPalette.crimsonAlert,
      icon: Icons.shield_outlined,
      isLivePulsing: true,
    );
  }

  /// Factory for VIP / Gold accent badge
  factory RoyalStatusBadge.gold({required String label, IconData? icon}) {
    return RoyalStatusBadge(
      label: label,
      color: AppPalette.imperialGold,
      icon: icon ?? Icons.workspace_premium_rounded,
    );
  }

  @override
  State<RoyalStatusBadge> createState() => _RoyalStatusBadgeState();
}

class _RoyalStatusBadgeState extends State<RoyalStatusBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isLivePulsing) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant RoyalStatusBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLivePulsing && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isLivePulsing && _pulseController.isAnimating) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: widget.color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.color.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isLivePulsing)
              AnimatedBuilder(
                animation: _pulseAnim,
                builder: (context, _) {
                  return Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(
                            alpha: 0.6 * _pulseAnim.value,
                          ),
                          blurRadius: 6 * _pulseAnim.value,
                          spreadRadius: 1 * _pulseAnim.value,
                        ),
                      ],
                    ),
                  );
                },
              )
            else if (widget.icon != null)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(widget.icon, size: 13, color: widget.color),
              ),
            Text(
              widget.label,
              style: AppTypography.cairoBold(
                fontSize: 10.5,
                color: widget.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
