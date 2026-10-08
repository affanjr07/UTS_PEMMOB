import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/responsive/responsive.dart';

/// Kartu bergaya neo-brutalist: border tegas + bayangan padat tanpa blur.
class NeoCard extends StatelessWidget {
  const NeoCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderColor,
    this.shadowColor,
    this.shadowOffset = 5,
    this.radius = 18,
    this.borderWeight = 1.8,
    this.align = Alignment.center,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;
  final Color? shadowColor;
  final double shadowOffset;
  final double radius;
  final double borderWeight;
  final Alignment align;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    final off = context.sz(shadowOffset);

    final card = Container(
      alignment: align,
      padding: padding ?? EdgeInsets.all(context.gap(18)),
      decoration: BoxDecoration(
        color: color ?? palette.surface,
        borderRadius: BorderRadius.circular(context.sz(radius)),
        border: Border.all(
          color: borderColor ?? palette.border,
          width: context.sz(borderWeight),
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? palette.shadow,
            offset: Offset(off, off),
            blurRadius: 0,
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.sz(radius)),
        child: card,
      ),
    );
  }
}
