import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/responsive/responsive.dart';

/// Dial hitung mundur waktu menjawab.
class TimerDial extends StatelessWidget {
  const TimerDial({
    super.key,
    required this.secondsLeft,
    required this.secondsTotal,
    this.size = 46,
  });

  final int secondsLeft;
  final int secondsTotal;
  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    final ratio = secondsTotal == 0 ? 0.0 : (secondsLeft / secondsTotal);
    final urgent = secondsLeft <= 5;
    final d = context.sz(size);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: ratio.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return AnimatedScale(
          scale: urgent ? 1 + 0.06 * math.sin(secondsLeft * math.pi) : 1,
          duration: const Duration(milliseconds: 300),
          child: SizedBox(
            width: d,
            height: d,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size.square(d),
                  painter: _DialPainter(
                    progress: value,
                    strokeWidth: context.sz(5),
                    track: palette.surfaceAlt,
                    color: urgent ? palette.danger : palette.accent,
                  ),
                ),
                Text(
                  '$secondsLeft',
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontWeight: FontWeight.w800,
                    fontSize: context.fs(15),
                    color: urgent ? palette.danger : palette.text,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DialPainter extends CustomPainter {
  _DialPainter({
    required this.progress,
    required this.strokeWidth,
    required this.track,
    required this.color,
  });

  final double progress;
  final double strokeWidth;
  final Color track;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(
      rect,
      0,
      2 * math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = track,
    );

    if (progress <= 0) return;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_DialPainter old) =>
      old.progress != progress || old.color != color;
}
