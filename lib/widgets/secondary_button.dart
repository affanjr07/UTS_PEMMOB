import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/responsive/responsive.dart';
import '../core/theme/app_type.dart';

/// Tombol sekunder: transparan dengan bayangan padat, animasi tekan.
class SecondaryButton extends StatefulWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fillWidth = true,
    this.height = 52,
    this.color,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool fillWidth;
  final double height;
  final Color? color;

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton>
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

    return GestureDetector(
      onTapDown: (_) => _press.forward(),
      onTapUp: (_) => _press.reverse(),
      onTapCancel: () => _press.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _press,
        builder: (context, child) {
          final t = Curves.easeOutCubic.transform(_press.value);
          return Transform.translate(
            offset: Offset(context.sz(4) * t, context.sz(4) * t),
            child: child,
          );
        },
        child: Container(
          width: widget.fillWidth ? double.infinity : null,
          height: context.sz(widget.height),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: context.gap(22)),
          decoration: BoxDecoration(
            color: widget.color ?? palette.surface,
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  widget.label.toUpperCase(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.labelStyle(
                    fontSize: context.fs(13),
                    color: palette.text,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
              if (widget.icon != null) ...[
                SizedBox(width: context.gap(8)),
                Icon(widget.icon, size: context.sz(18), color: palette.text),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
