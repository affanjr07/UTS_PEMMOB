import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/responsive/responsive.dart';
import '../core/theme/app_type.dart';

enum OptionState { idle, selected, correct, wrong, dimmed }

/// Tile jawaban pilihan ganda dengan animasi perubahan state yang halus.
class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.letter,
    required this.text,
    required this.state,
    required this.onTap,
    this.index = 0,
  });

  final String letter;
  final String text;
  final OptionState state;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);

    final (bg, border, fg) = switch (state) {
      OptionState.idle => (palette.surface, palette.border, palette.text),
      OptionState.selected => (palette.muted, palette.border, palette.text),
      OptionState.correct => (palette.success, palette.border, palette.surface),
      OptionState.wrong => (palette.danger, palette.border, palette.surface),
      OptionState.dimmed => (
        palette.surfaceAlt,
        palette.border,
        palette.textSoft,
      ),
    };

    final badgeBg = switch (state) {
      OptionState.correct => palette.surface,
      OptionState.wrong => palette.surface,
      OptionState.selected => palette.surface,
      _ => palette.surfaceAlt,
    };

    return TweenAnimationBuilder<double>(
      tween: Tween(end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: context.gap(14),
            vertical: context.gap(13),
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(context.sz(16)),
            border: Border.all(color: border, width: context.sz(1.8)),
            boxShadow: state == OptionState.idle || state == OptionState.dimmed
                ? [
                    BoxShadow(
                      color: palette.shadow,
                      offset: Offset(context.sz(3), context.sz(3)),
                      blurRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                width: context.sz(36),
                height: context.sz(36),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(context.sz(11)),
                  border: Border.all(color: fg, width: context.sz(1.6)),
                ),
                child: state == OptionState.correct
                    ? Icon(Icons.check_rounded, size: context.sz(20), color: fg)
                    : state == OptionState.wrong
                    ? Icon(Icons.close_rounded, size: context.sz(20), color: fg)
                    : Text(
                        letter,
                        style: AppType.displayStyle(
                          fontSize: context.fs(16),
                          color: fg,
                          weight: FontWeight.w700,
                        ),
                      ),
              ),
              SizedBox(width: context.gap(13)),
              Expanded(
                child: Text(
                  text,
                  style: AppType.bodyStyle(
                    fontSize: context.fs(14.5),
                    color: fg,
                    weight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ),
              SizedBox(width: context.gap(6)),
              AnimatedScale(
                scale: state == OptionState.dimmed ? 0.7 : 1,
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutBack,
                child: Icon(
                  state == OptionState.correct
                      ? Icons.verified_rounded
                      : state == OptionState.wrong
                      ? Icons.cancel_rounded
                      : Icons.circle_outlined,
                  size: context.sz(18),
                  color: fg.withValues(
                    alpha: state == OptionState.idle ? 0.35 : 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
