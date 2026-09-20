import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_palette.dart';

/// Reusable Royal Frosted Glass Container with specular hairline border.
class RoyalGlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blur;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Border? border;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  final bool enableBlur;

  const RoyalGlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 22,
    this.padding,
    this.margin,
    this.blur = 18,
    this.enableBlur = false, // Defaults to false for high-performance 60fps rendering in lists
    this.backgroundColor,
    this.gradient,
    this.border,
    this.shadows,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget innerBox = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppPalette.cardDark.withValues(alpha: 0.85),
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ??
            Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1,
            ),
      ),
      child: child,
    );

    Widget content = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: (enableBlur && blur > 0)
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: innerBox,
            )
          : innerBox,
    );

    if (shadows != null && shadows!.isNotEmpty) {
      content = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: shadows,
        ),
        child: content,
      );
    }

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      );
    }

    return content;
  }
}
