import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/responsive/responsive.dart';
import '../core/theme/app_type.dart';

/// Strip teks berjalan tanpa henti â€” aksen editorial khas aplikasi.
class MarqueeTicker extends StatefulWidget {
  const MarqueeTicker({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.height = 34,
    this.speed = 42,
  });

  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final double speed;

  @override
  State<MarqueeTicker> createState() => _MarqueeTickerState();
}

class _MarqueeTickerState extends State<MarqueeTicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );
  double _unitWidth = 0;
  String _measuredFor = '';

  @override
  void initState() {
    super.initState();
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _measure(TextStyle style, double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(text: widget.text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: maxWidth);
    return painter.width;
  }

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    final style = AppType.labelStyle(
      fontSize: context.fs(11),
      color: widget.textColor ?? palette.background,
      letterSpacing: 2.2,
    );
    final key = '${widget.text}|${context.fs(11)}';

    return ClipRect(
      child: Container(
        height: context.sz(widget.height),
        width: double.infinity,
        color: widget.backgroundColor ?? palette.text,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (key != _measuredFor) {
              _measuredFor = key;
              _unitWidth = _measure(style, constraints.maxWidth);
            }
            if (_unitWidth <= 0) return const SizedBox.shrink();

            final count = (constraints.maxWidth / _unitWidth).ceil() + 2;

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final offset = -_controller.value * _unitWidth;
                return Transform.translate(
                  offset: Offset(offset, 0),
                  child: OverflowBox(
                    minWidth: 0,
                    maxWidth: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < count; i++)
                          SizedBox(
                            width: _unitWidth,
                            child: Text(
                              widget.text,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              softWrap: false,
                              style: style,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
