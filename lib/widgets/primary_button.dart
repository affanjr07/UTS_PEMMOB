import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/responsive/responsive.dart';
import '../core/theme/app_type.dart';

/// Tombol utama dengan animasi tekan (scale + bayangan mengecil).
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fillWidth = true,
    this.height = 56,
    this.color,
    this.textColor,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool fillWidth;
  final double height;
  final Color? color;
  final Color? textColor;
  final bool enabled;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 110),
    reverseDuration: const Duration(milliseconds: 180),
  );

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    final height = context.sz(widget.height);
    final bg = widget.enabled
        ? (widget.color ?? palette.accent)
        : palette.surfaceAlt;
    final fg = widget.enabled
        ? (widget.textColor ?? palette.surface)
        : palette.textSoft;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            widget.label.toUpperCase(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppType.labelStyle(
              fontSize: context.fs(14),
              color: fg,
              letterSpacing: 1.4,
            ),
          ),
        ),
        if (widget.icon != null) ...[
          SizedBox(width: context.gap(9)),
          Icon(widget.icon, size: context.sz(19), color: fg),
        ],
      ],
    );

    return GestureDetector(
      onTapDown: widget.enabled ? (_) => _press.forward() : null,
      onTapUp: (_) => _press.reverse(),
      onTapCancel: () => _press.reverse(),
      onTap: widget.enabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _press,
        builder: (context, child) {
          final t = Curves.easeOutCubic.transform(_press.value);
          return Transform.translate(
            offset: Offset(context.sz(4) * t, context.sz(4) * t),
            child: Transform.scale(scale: 1 - 0.03 * t, child: child),
          );
        },
        child: Container(
          width: widget.fillWidth ? double.infinity : null,
          height: height,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: context.gap(24)),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(context.sz(16)),
            border: Border.all(color: palette.border, width: context.sz(1.8)),
            boxShadow: [
              BoxShadow(
                color: palette.shadow,
                offset: Offset(context.sz(4), context.sz(4)),
                blurRadius: 0,
              ),
            ],
          ),
          child: content,
        ),
      ),
    );
  }
}
