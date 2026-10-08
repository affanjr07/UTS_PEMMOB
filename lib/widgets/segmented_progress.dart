import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/responsive/responsive.dart';

/// Bilah progres bersegmen â€” menampilkan posisi soal aktif.
class SegmentedProgress extends StatelessWidget {
  const SegmentedProgress({
    super.key,
    required this.total,
    required this.current,
    required this.filled,
    this.height = 10,
  });

  final int total;
  final int current;

  /// Jumlah segmen yang sudah terjawab.
  final int filled;
  final double height;

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);

    return Row(
      children: [
        for (var i = 0; i < total; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: i == total - 1 ? 0 : context.gap(5),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 380),
                curve: Curves.easeOutCubic,
                height: context.sz(height),
                decoration: BoxDecoration(
                  color: i < filled
                      ? palette.accent
                      : i == current
                      ? palette.muted
                      : palette.surfaceAlt,
                  borderRadius: BorderRadius.circular(context.sz(6)),
                  border: Border.all(
                    color: palette.border,
                    width: i == current ? context.sz(1.4) : 0,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
