import 'package:flutter/material.dart';

/// Tipografi kustom: Syne (display) + Space Grotesk (teks & label).
class AppType {
  AppType._();

  static const String display = 'Syne';
  static const String body = 'SpaceGrotesk';

  static TextStyle displayStyle({
    required double fontSize,
    required Color color,
    FontWeight weight = FontWeight.w800,
    double height = 1.04,
    double letterSpacing = -0.6,
  }) {
    return TextStyle(
      fontFamily: display,
      fontWeight: weight,
      fontSize: fontSize,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle bodyStyle({
    required double fontSize,
    required Color color,
    FontWeight weight = FontWeight.w400,
    double height = 1.45,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: body,
      fontWeight: weight,
      fontSize: fontSize,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Label huruf kapital kecil dengan jarak huruf lebar.
  static TextStyle labelStyle({
    required double fontSize,
    required Color color,
    FontWeight weight = FontWeight.w700,
    double letterSpacing = 1.6,
  }) {
    return TextStyle(
      fontFamily: body,
      fontWeight: weight,
      fontSize: fontSize,
      color: color,
      height: 1.2,
      letterSpacing: letterSpacing,
    );
  }
}
