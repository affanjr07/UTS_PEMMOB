import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/responsive/responsive.dart';
import '../core/theme/app_type.dart';
import 'neo_card.dart';

/// Kartu statistik ringkas (dipakai di layar hasil & pembahasan).
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.accent,
    this.valueBuilder,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? accent;

  /// Jika disediakan, nilai animasi angka akan dirender lewat builder ini.
  final Widget Function(BuildContext context, Widget child)? valueBuilder;

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    final accentColor = accent ?? palette.accent;

    final valueWidget = Text(
      value,
      style: AppType.displayStyle(
        fontSize: context.fs(24),
        color: palette.text,
        weight: FontWeight.w800,
      ),
    );

    return NeoCard(
      padding: EdgeInsets.symmetric(
        horizontal: context.gap(14),
        vertical: context.gap(14),
      ),
      shadowOffset: 3,
      radius: 16,
      child: Row(
        children: [
          Container(
            width: context.sz(34),
            height: context.sz(34),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(context.sz(10)),
              border: Border.all(color: palette.border, width: context.sz(1.4)),
            ),
            child: Icon(icon, size: context.sz(18), color: palette.surface),
          ),
          SizedBox(width: context.gap(11)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.labelStyle(
                    fontSize: context.fs(9.5),
                    color: palette.textSoft,
                    letterSpacing: 1.4,
                  ),
                ),
                SizedBox(height: context.gap(2)),
                DefaultTextStyle(
                  style: AppType.displayStyle(
                    fontSize: context.fs(24),
                    color: palette.text,
                    weight: FontWeight.w800,
                  ),
                  child: valueBuilder == null
                      ? FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: valueWidget,
                        )
                      : valueBuilder!(context, valueWidget),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
