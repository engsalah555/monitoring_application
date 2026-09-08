import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_palette.dart';
import '../../theme/app_typography.dart';

enum RoyalButtonVariant {
  primary, // Royal Sapphire Gradient
  gold, // Imperial Champagne Gold Gradient
  glass, // Frosted Glass Bordered
  danger, // Emergency Crimson Gradient
}

/// Unified Interactive Royal Button with micro-feedback and haptics.
class RoyalButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final RoyalButtonVariant variant;
  final double height;
  final double borderRadius;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;

  const RoyalButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = RoyalButtonVariant.primary,
    this.height = 48,
    this.borderRadius = 16,
    this.isLoading = false,
    this.padding,
  });

  @override
  State<RoyalButton> createState() => _RoyalButtonState();
}

class _RoyalButtonState extends State<RoyalButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    Gradient? gradient;
    Color? bgColor;
    Color textColor = Colors.white;
    Border? border;
    List<BoxShadow>? shadows;

    switch (widget.variant) {
      case RoyalButtonVariant.primary:
        gradient = AppPalette.royalSapphireGradient;
        shadows = isEnabled
            ? [
                BoxShadow(
                  color: AppPalette.primary.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : null;
        break;
      case RoyalButtonVariant.gold:
        gradient = AppPalette.imperialGoldGradient;
        textColor = const Color(0xFF1E293B);
        shadows = isEnabled
            ? [
                BoxShadow(
                  color: AppPalette.imperialGold.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : null;
        break;
      case RoyalButtonVariant.glass:
        bgColor = AppPalette.cardDark.withValues(alpha: 0.6);
        border = Border.all(
          color: Colors.white.withValues(alpha: 0.16),
          width: 1,
        );
        break;
      case RoyalButtonVariant.danger:
        gradient = AppPalette.emergencyGradient;
        shadows = isEnabled
            ? [
                BoxShadow(
                  color: AppPalette.crimsonAlert.withValues(alpha: 0.4),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                )
              ]
            : null;
        break;
    }

    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: isEnabled
            ? (_) {
                setState(() => _isPressed = false);
                HapticFeedback.lightImpact();
                widget.onPressed?.call();
              }
            : null,
        onTapCancel: () => setState(() => _isPressed = false),
        child: Container(
          height: widget.height,
          padding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            gradient: gradient,
            color: bgColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: border,
            boxShadow: shadows,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(textColor),
                  ),
                )
              else ...[
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 18, color: textColor),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: AppTypography.cairoBold(
                    fontSize: 12.5,
                    color: textColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
