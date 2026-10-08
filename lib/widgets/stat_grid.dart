import 'package:flutter/material.dart';

import '../core/responsive/responsive.dart';

/// Grid statistik responsif: jumlah kolom menyesuaikan lebar layar
/// (1 kolom di ponsel sempit, 2 di ponsel umum, 3 di tablet).
class StatGrid extends StatelessWidget {
  const StatGrid({
    super.key,
    required this.children,
    this.itemMinWidth = 165,
    this.itemHeight = 84,
    this.maxColumns = 3,
  });

  final List<Widget> children;
  final double itemMinWidth;
  final double itemHeight;
  final int maxColumns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = context.gap(12);
        final cols = ((constraints.maxWidth + gap) / context.sz(itemMinWidth))
            .floor()
            .clamp(1, maxColumns);
        final cellWidth = (constraints.maxWidth - gap * (cols - 1)) / cols;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: cols,
          mainAxisSpacing: gap,
          crossAxisSpacing: gap,
          childAspectRatio: cellWidth / context.sz(itemHeight),
          children: children,
        );
      },
    );
  }
}
