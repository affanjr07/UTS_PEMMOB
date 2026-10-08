import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/responsive/responsive.dart';
import '../core/theme/app_type.dart';

/// Label huruf kapital kecil dengan bullet berwarna â€” penanda mikro khas aplikasi.
class MicroLabel extends StatelessWidget {
  const MicroLabel(
    this.text, {
    super.key,
    this.color,
    this.bulletColor,
    this.icon,
    this.fontSize = 11,
    this.withBullet = true,
  });

  final String text;
  final Color? color;
  final Color? bulletColor;
  final IconData? icon;
  final double fontSize;
  final bool withBullet;

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    final style = AppType.labelStyle(
      fontSize: context.fs(fontSize),
      color: color ?? palette.textSoft,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (withBullet) ...[
          Container(
            width: context.sz(fontSize * 0.72),
            height: context.sz(fontSize * 0.72),
            decoration: BoxDecoration(
              color: bulletColor ?? palette.accent,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: context.gap(7)),
        ],
        if (icon != null) ...[
          Icon(
            icon,
            size: context.sz(fontSize + 4),
            color: color ?? palette.textSoft,
          ),
          SizedBox(width: context.gap(6)),
        ],
        Flexible(
          child: Text(
            text.toUpperCase(),
            style: style,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
