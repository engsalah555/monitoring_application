import 'dart:math' as math;
import 'package:flutter/material.dart';

class RadarRingWidget extends StatefulWidget {
  final double size;
  final Color borderColor;
  final Widget child;
  final bool isAlert;

  const RadarRingWidget({
    super.key,
    this.size = 64,
    required this.borderColor,
    required this.child,
    this.isAlert = false,
  });

  @override
  State<RadarRingWidget> createState() => _RadarRingWidgetState();
}

class _RadarRingWidgetState extends State<RadarRingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer border ring
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.borderColor,
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.borderColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                )
              ],
            ),
          ),
          // Radar Sweep Shader Overlay
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: Container(
                  width: widget.size - 4,
                  height: widget.size - 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        widget.borderColor.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.25],
                    ),
                  ),
                ),
              );
            },
          ),
          // Content Widget inside ring
          ClipOval(
            child: SizedBox(
              width: widget.size - 8,
              height: widget.size - 8,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
