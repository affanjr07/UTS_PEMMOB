import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/responsive/responsive.dart';
import '../core/theme/app_type.dart';

/// Chip kategori soal â€” dipakai pada layar kuis maupun pembahasan.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    this.color,
    this.filled = false,
  });

  final String label;
  final Color? color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    final accent = color ?? palette.accentAlt;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.gap(10),
        vertical: context.gap(5),
      ),
      decoration: BoxDecoration(
        color: filled ? accent : palette.surface,
        borderRadius: BorderRadius.circular(context.sz(999)),
        border: Border.all(color: palette.border, width: context.sz(1.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.sz(7),
            height: context.sz(7),
            decoration: BoxDecoration(
              color: filled ? palette.surface : accent,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: context.gap(6)),
          Text(
            label.toUpperCase(),
            style: AppType.labelStyle(
              fontSize: context.fs(10),
              color: filled ? palette.surface : palette.text,
              letterSpacing: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
