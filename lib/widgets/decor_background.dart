import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Latar dekoratif berisi bentuk-bentuk melayang yang bergerak pelan.
/// Dipasang di belakang konten layar utama agar terasa hidup.
class DecorBackground extends StatefulWidget {
  const DecorBackground({super.key, required this.child, this.animate = true});

  final Widget child;
  final bool animate;

  @override
  State<DecorBackground> createState() => _DecorBackgroundState();
}

class _DecorBackgroundState extends State<DecorBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);

    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _DecorPainter(
                t: _controller,
                dot: palette.text.withValues(alpha: 0.14),
                ring: palette.accent.withValues(alpha: 0.10),
                spark: palette.accentAlt.withValues(alpha: 0.16),
              ),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _DecorPainter extends CustomPainter {
  _DecorPainter({
    required Animation<double> t,
    required this.dot,
    required this.ring,
    required this.spark,
  }) : repaint = t;

  final Animation<double> repaint;
  final Color dot;
  final Color ring;
  final Color spark;

  static const double _cols = 7;
  static const double _rows = 6;

  @override
  void paint(Canvas canvas, Size size) {
    final phase = repaint.value * 2 * math.pi;
    final paint = Paint()..strokeCap = StrokeCap.round;

    // Titik-titik grid di sudut kiri atas.
    final gx = size.width * 0.06;
    final gy = size.height * 0.06;
    final step = size.width * 0.055;
    paint.color = dot;
    for (var r = 0; r < _rows; r++) {
      for (var c = 0; c < _cols; c++) {
        final fade = 1 - (c / _cols) * 0.7 - (r / _rows) * 0.4;
        if (fade <= 0) continue;
        paint.color = dot.withValues(alpha: 0.9 * fade.clamp(0, 1));
        canvas.drawCircle(
          Offset(gx + c * step, gy + r * step),
          size.width * 0.005,
          paint,
        );
      }
    }

    // Cincin besar melayang kanan bawah.
    final bob = math.sin(phase) * size.height * 0.012;
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.012
      ..color = ring;
    canvas.drawCircle(
      Offset(size.width * 0.88, size.height * 0.82 + bob),
      size.width * 0.18,
      paint,
    );

    // Busur kiri bawah.
    paint
      ..strokeWidth = size.width * 0.008
      ..color = spark;
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width * 0.08, size.height * 0.9 + bob * 0.6),
        radius: size.width * 0.14,
      ),
      -0.6,
      2.1,
      false,
      paint,
    );

    // Tanda plus kecil.
    paint.color = spark;
    final plus = size.width * 0.018;
    const points = [Offset(0.78, 0.18), Offset(0.12, 0.52), Offset(0.66, 0.72)];
    for (var i = 0; i < points.length; i++) {
      final p = Offset(
        points[i].dx * size.width,
        points[i].dy * size.height + math.sin(phase + i) * 6,
      );
      canvas.drawLine(p - Offset(plus, 0), p + Offset(plus, 0), paint);
      canvas.drawLine(p - Offset(0, plus), p + Offset(0, plus), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DecorPainter old) => true;
}
