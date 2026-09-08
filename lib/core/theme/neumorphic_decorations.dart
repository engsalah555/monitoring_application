import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Utility class for Neumorphic & Soft Claymorphic visual styles matching reference design.
class NeumorphicDecorations {
  const NeumorphicDecorations._();

  /// Soft raised neumorphic surface decoration (light top-left highlight + dark bottom-right shadow)
  static BoxDecoration softRaised({
    Color color = AppColors.clayCard,
    double borderRadius = 24.0,
    Border? border,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      border: border ??
          Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.9),
          offset: const Offset(-6, -6),
          blurRadius: 12,
        ),
        BoxShadow(
          color: const Color(0xFFA6B4C9).withValues(alpha: 0.4),
          offset: const Offset(6, 6),
          blurRadius: 14,
        ),
      ],
    );
  }

  /// Dark raised neumorphic container for top header sections
  static BoxDecoration darkRaised({
    Color color = AppColors.darkIndigo,
    double borderRadius = 28.0,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF0C101F).withValues(alpha: 0.6),
          offset: const Offset(4, 8),
          blurRadius: 20,
        ),
        BoxShadow(
          color: const Color(0xFF2E385B).withValues(alpha: 0.3),
          offset: const Offset(-2, -2),
          blurRadius: 10,
        ),
      ],
    );
  }

  /// Pressed / Debossed inner look
  static BoxDecoration debossed({
    Color color = AppColors.clayBg,
    double borderRadius = 20.0,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFFA6B4C9).withValues(alpha: 0.5),
          offset: const Offset(3, 3),
          blurRadius: 6,
        ),
      ],
    );
  }
}

/// Custom Clipper for creating fluid wave header shapes
class HeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 35);

    final firstControlPoint = Offset(size.width * 0.25, size.height);
    final firstEndPoint = Offset(size.width * 0.5, size.height - 20);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 0.75, size.height - 40);
    final secondEndPoint = Offset(size.width, size.height - 10);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
