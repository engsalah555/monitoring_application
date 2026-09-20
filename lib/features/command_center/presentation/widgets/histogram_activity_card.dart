import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';

/// Neon Histogram Activity Chart — inspired by IMG_8105 telemetry card.
///
/// Displays animated violet waveform bars with a cyan sparkline overlay,
/// coral lower-bound line, and live statistical labels — all on an obsidian
/// matte surface with a violet glow border.
class HistogramActivityCard extends StatefulWidget {
  const HistogramActivityCard({super.key});

  @override
  State<HistogramActivityCard> createState() => _HistogramActivityCardState();
}

class _HistogramActivityCardState extends State<HistogramActivityCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  // Simulated activity heights — 0.0 to 1.0 (relative)
  final List<double> _barHeights = const [
    0.38, 0.60, 0.50, 0.72, 0.90, 0.78, 0.45,
    0.65, 0.88, 0.55, 0.42, 0.70, 0.95, 0.80,
    0.60, 0.35, 0.52, 0.68, 0.85, 0.74, 0.48,
    0.62, 0.77, 0.40, 0.56, 0.82, 0.92, 0.65,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppPalette.primary.withValues(alpha: 0.25),
          width: 1,
        ),
        boxShadow: AppPalette.violetCardShadow,
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 14),
          _buildStatRow(),
          const SizedBox(height: 16),
          SizedBox(
            height: 88,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (_, __) => CustomPaint(
                painter: _HistogramPainter(
                  barHeights: _barHeights,
                  progress: _animation.value,
                ),
                size: const Size(double.infinity, 88),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildTimeAxis(),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            gradient: AppPalette.violetGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.bar_chart_rounded,
            size: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'نشاط الكاميرات',
                style: AppTypography.cairoBold(
                  fontSize: 13,
                  color: AppPalette.textLightPrimary,
                ),
              ),
              Text(
                'تحليل الحركة · آخر 7 أيام',
                style: AppTypography.cairoRegular(
                  fontSize: 10,
                  color: AppPalette.textLightMuted,
                ),
              ),
            ],
          ),
        ),
        // Live badge
        _LiveBadge(),
      ],
    );
  }

  // ── Stats Row ─────────────────────────────────────────────────────────────
  Widget _buildStatRow() {
    return const Row(
      children: [
        _StatChip(
          label: 'الذروة',
          value: '95%',
          color: AppPalette.primary,
        ),
        SizedBox(width: 10),
        _StatChip(
          label: 'المتوسط',
          value: '64%',
          color: AppPalette.cyanLight,
        ),
        SizedBox(width: 10),
        _StatChip(
          label: 'الحد الأدنى',
          value: '35%',
          color: AppPalette.coral,
        ),
      ],
    );
  }

  // ── Time Axis ─────────────────────────────────────────────────────────────
  Widget _buildTimeAxis() {
    const labels = ['الجمعة', 'السبت', 'الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'اليوم'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels
          .map(
            (l) => Text(
              l,
              style: AppTypography.cairoRegular(
                fontSize: 8.5,
                color: AppPalette.textLightMuted,
              ),
            ),
          )
          .toList(),
    );
  }
}

// ── Live Badge ────────────────────────────────────────────────────────────────

class _LiveBadge extends StatefulWidget {
  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppPalette.emeraldGlow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppPalette.emeraldLive.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: _pulse,
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppPalette.emeraldLive,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'مباشر',
            style: AppTypography.cairoBold(
              fontSize: 9,
              color: AppPalette.emeraldLive,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat Chip ─────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTypography.cairoBold(fontSize: 11, color: color),
              ),
              Text(
                label,
                style: AppTypography.cairoRegular(
                  fontSize: 8.5,
                  color: AppPalette.textLightMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Histogram CustomPainter ───────────────────────────────────────────────────

class _HistogramPainter extends CustomPainter {
  final List<double> barHeights;
  final double progress;

  const _HistogramPainter({
    required this.barHeights,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final count = barHeights.length;
    final barWidth = (size.width / count) * 0.55;
    final spacing = size.width / count;

    // ── Draw bars ────────────────────────────────────────────────────────────
    for (int i = 0; i < count; i++) {
      final h = barHeights[i] * size.height * progress;
      final x = i * spacing + (spacing - barWidth) / 2;
      final top = size.height - h;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, top, barWidth, h),
        const Radius.circular(3),
      );

      // Alternate between vibrant and dim gradient bars (IMG_8105 look)
      final gradient = (i % 3 != 0)
          ? AppPalette.histogramBarGradient
          : AppPalette.histogramBarDimGradient;

      final paint = Paint()
        ..shader = gradient.createShader(
          Rect.fromLTWH(x, 0, barWidth, size.height),
        );

      canvas.drawRRect(rect, paint);
    }

    // ── Draw cyan sparkline ────────────────────────────────────────────────
    if (progress > 0.3) {
      _drawSparkline(canvas, size, spacing, AppPalette.cyanLight,
          opacity: (progress - 0.3) / 0.7);
    }

    // ── Draw coral lower-bound line ────────────────────────────────────────
    _drawHorizontalDashLine(canvas, size, y: size.height * 0.62);
  }

  void _drawSparkline(
    Canvas canvas,
    Size size,
    double spacing,
    Color color, {
    required double opacity,
  }) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.75 * opacity)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    for (int i = 0; i < barHeights.length; i++) {
      final x = i * spacing + spacing / 2;
      final y = size.height - barHeights[i] * size.height * progress;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = (i - 1) * spacing + spacing / 2;
        final prevY =
            size.height - barHeights[i - 1] * size.height * progress;
        final cp1x = prevX + (x - prevX) * 0.5;
        path.cubicTo(cp1x, prevY, cp1x, y, x, y);
      }
    }
    canvas.drawPath(path, paint);

    // Sparkline glow
    canvas.drawPath(
      path,
      paint
        ..color = color.withValues(alpha: 0.15 * opacity)
        ..strokeWidth = 6
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  void _drawHorizontalDashLine(Canvas canvas, Size size, {required double y}) {
    final paint = Paint()
      ..color = AppPalette.coral.withValues(alpha: 0.55)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(math.min(startX + dashWidth, size.width), y),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_HistogramPainter old) =>
      old.progress != progress || old.barHeights != barHeights;
}
