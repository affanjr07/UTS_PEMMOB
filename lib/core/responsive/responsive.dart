import 'package:flutter/material.dart';

/// Helper ukuran dinamis agar tidak ada nilai UI yang di-hardcode.
/// Semua ukuran font/jarak dihitung relatif terhadap lebar layar acuan (390px).
extension ResponsiveContext on BuildContext {
  MediaQueryData get mq => MediaQuery.of(this);

  double get screenWidth => mq.size.width;
  double get screenHeight => mq.size.height;
  double get paddingTop => mq.padding.top;
  double get paddingBottom => mq.padding.bottom;
  double get minHeight => screenHeight - paddingTop - paddingBottom;

  bool get isTablet => screenWidth >= 600;
  bool get isLandscape => screenWidth > screenHeight;

  /// Faktor skala UI. Dibatasi agar tetap proporsional di tablet maupun web.
  double get uiScale => (screenWidth / 390).clamp(0.82, 1.38);

  /// Skala vertikal (lebih netral untuk layar sangat tinggi/rendah).
  double get uiScaleY => (screenHeight / 844).clamp(0.85, 1.25);

  /// Ukuran font dinamis.
  double fs(double size) => size * uiScale;

  /// Ukuran elemen (radius, tinggi tombol, ikon, dll).
  double sz(double size) => size * uiScale;

  /// Jarak/spasi dinamis.
  double gap(double size) => size * uiScale;

  /// Lebar konten maksimum agar tetap rapi di tablet / browser lebar.
  double get contentMaxWidth {
    if (!isTablet) return screenWidth;
    if (screenWidth >= 1100) return 780;
    if (screenWidth >= 800) return 680;
    return 560;
  }

  /// Lebar kolom untuk grid responsif.
  int gridColumns({required double itemMinWidth, int max = 4}) {
    final cols = (contentMaxWidth / itemMinWidth).floor();
    return cols.clamp(1, max);
  }
}

/// Membungkus konten agar tidak melebar berlebihan di layar besar.
class ContentMaxWidth extends StatelessWidget {
  const ContentMaxWidth({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.contentMaxWidth),
        child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
      ),
    );
  }
}
