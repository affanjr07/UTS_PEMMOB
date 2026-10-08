import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/theme/app_colors.dart';
import '../core/responsive/responsive.dart';

/// Logo merek (aset SVG) â€” dikemas dengan Hero agar mulus antar halaman.
class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.size = 64,
    this.tag = 'brand-logo',
    this.tint,
  });

  final double size;
  final String tag;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    final s = context.sz(size);

    return Hero(
      tag: tag,
      child: Container(
        width: s,
        height: s,
        padding: EdgeInsets.all(context.gap(s * 0.16)),
        decoration: BoxDecoration(
          color: tint == null ? palette.surface : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: palette.border, width: context.sz(1.8)),
          boxShadow: [
            BoxShadow(
              color: palette.shadow,
              offset: Offset(context.sz(4), context.sz(4)),
              blurRadius: 0,
            ),
          ],
        ),
        child: SvgPicture.asset(
          'assets/images/logo_mark.svg',
          colorFilter: ColorFilter.mode(
            tint ?? palette.accent,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
