import 'package:flutter/material.dart';
import '../../theme/app_palette.dart';
import '../../theme/app_typography.dart';
import 'royal_glass.dart';

/// Standardized Luxury Royal Card Component.
/// Eliminates repetitive Container / BoxDecoration declarations across the app.
class RoyalCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool hasGlowBorder;
  final Color? borderColor;
  final Gradient? backgroundGradient;

  const RoyalCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.trailing,
    this.padding,
    this.margin,
    this.borderRadius = 22,
    this.onTap,
    this.hasGlowBorder = false,
    this.borderColor,
    this.backgroundGradient,
  });

  @override
  Widget build(BuildContext context) {
    return RoyalGlassContainer(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(18),
      borderRadius: borderRadius,
      onTap: onTap,
      gradient: backgroundGradient ??
          LinearGradient(
            colors: [
              AppPalette.cardDark.withValues(alpha: 0.85),
              AppPalette.surfaceDark.withValues(alpha: 0.75),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
      border: Border.all(
        color: borderColor ??
            (hasGlowBorder
                ? AppPalette.borderGlow
                : Colors.white.withValues(alpha: 0.1)),
        width: hasGlowBorder ? 1.4 : 1.0,
      ),
      shadows: hasGlowBorder
          ? [
              BoxShadow(
                color: AppPalette.cyanLight.withValues(alpha: 0.15),
                blurRadius: 18,
                spreadRadius: 1,
              ),
              ...AppPalette.softCardShadow,
            ]
          : AppPalette.softCardShadow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null || icon != null) ...[
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: (iconColor ?? AppPalette.primary)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (iconColor ?? AppPalette.primary)
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 18,
                      color: iconColor ?? AppPalette.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: AppTypography.cairoBold(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: AppTypography.cairoRegular(
                            fontSize: 11,
                            color: AppPalette.textLightMuted,
                          ),
                        ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 14),
          ],
          child,
        ],
      ),
    );
  }
}
