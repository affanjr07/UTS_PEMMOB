import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Ledakan konfeti kecil untuk memeriahkan layar hasil.
/// Murni CustomPainter (tanpa partikel berlebih), deterministik,
/// dan otomatis berhenti setelah animasi selesai.
class ConfettiBurst extends StatelessWidget {
  const ConfettiBurst({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    final colors = <Color>[
      palette.accent,
      palette.accentAlt,
      palette.muted,
      palette.success,
    ];
    return IgnorePointer(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 2600),
        curve: Curves.easeOut,
        builder: (context, progress, _) {
          return CustomPaint(
            painter: _ConfettiPainter(progress: progress, colors: colors),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.progress, required this.colors});

  final double progress;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    const count = 42;
    final origin = Offset(size.width / 2, -size.height * 0.02);

    for (var i = 0; i < count; i++) {
      final rnd = math.Random(1000 + i);
      final angle = rnd.nextDouble() * math.pi * 2;
      final speed = 0.32 + rnd.nextDouble() * 0.5;
      final delay = rnd.nextDouble() * 0.3;
      final width = 5.0 + rnd.nextDouble() * 8;
      final spin = (rnd.nextDouble() - 0.5) * 12;

      final lp = ((progress - delay) / (1 - delay)).clamp(0.0, 1.0);
      if (lp <= 0) continue;

      // Gravitasi sederhana: horizontal melambat, vertikal jatuh menggenap.
      final x = origin.dx + math.cos(angle) * speed * lp * size.width * 0.55;
      final y =
          origin.dy +
          (math.sin(angle) * speed * 0.45 + 1.35 * lp * lp) * size.height;
      if (y > size.height + 20) continue;

      final fade = lp < 0.65 ? 1.0 : (1 - lp) / 0.35;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(spin * lp);
      final paint = Paint()
        ..color = colors[i % colors.length].withValues(alpha: 0.9 * fade);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: width,
            height: width * 0.55,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.colors != colors;
}
