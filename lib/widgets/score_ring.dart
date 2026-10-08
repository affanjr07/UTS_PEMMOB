import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/responsive/responsive.dart';

/// Cincin skor animasi (custom painter) dengan ujung membulat.
class ScoreRing extends StatelessWidget {
  const ScoreRing({
    super.key,
    required this.progress,
    required this.child,
    this.size = 190,
    this.stroke = 16,
    this.progressColor,
    this.backgroundColor,
    this.trackColor,
  });

  final double progress;
  final Widget child;
  final double size;
  final double stroke;
  final Color? progressColor;
  final Color? backgroundColor;
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    final d = context.sz(size);

    return SizedBox(
      width: d,
      height: d,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 1400),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) {
          return CustomPaint(
            painter: _RingPainter(
              progress: value,
              strokeWidth: context.sz(stroke),
              progressColor: progressColor ?? palette.accent,
              trackColor: trackColor ?? palette.surfaceAlt,
              dotColor: backgroundColor ?? palette.surface,
            ),
            child: Center(child: child),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.progressColor,
    required this.trackColor,
    required this.dotColor,
  });

  final double progress;
  final double strokeWidth;
  final Color progressColor;
  final Color trackColor;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = trackColor;
    canvas.drawCircle(center, radius, track);

    if (progress > 0.001) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final arc = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = progressColor;
      canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, arc);

      // Titik penanda di ujung busur.
      final angle = -math.pi / 2 + 2 * math.pi * progress;
      final dot = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawCircle(dot, strokeWidth * 0.62, Paint()..color = dotColor);
      canvas.drawCircle(
        dot,
        strokeWidth * 0.62,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth * 0.28
          ..color = progressColor,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress ||
      old.progressColor != progressColor ||
      old.strokeWidth != strokeWidth;
}
