import 'package:flutter/material.dart';

/// Palet warna khas "Nalar Nusantara": kertas bone, tinta gelap, jingga bakar.
class AppColors {
  AppColors._();

  // Tema terang (Bone)
  static const Color bone = Color(0xFFF4F0E6);
  static const Color paper = Color(0xFFFFFDF6);
  static const Color ink = Color(0xFF16170F);
  static const Color inkSoft = Color(0xFF5C5E4E);
  static const Color line = Color(0xFF16170F);

  // Tema gelap (Midnight)
  static const Color night = Color(0xFF101109);
  static const Color nightSurface = Color(0xFF1B1C14);
  static const Color nightLine = Color(0xFF3C3E2F);
  static const Color nightSoft = Color(0xFFA7A995);

  // Aksen
  static const Color orange = Color(0xFFFF5A1F);
  static const Color orangeDark = Color(0xFFE4441B);
  static const Color teal = Color(0xFF0E7C7B);
  static const Color tealBright = Color(0xFF2BA9A4);
  static const Color sun = Color(0xFFFFC24B);
  static const Color red = Color(0xFFC23A22);
  static const Color green = Color(0xFF1B7F4F);
  static const Color greenBright = Color(0xFF3FBE7C);

  static const List<Color> heroGradient = [orange, sun];
}

/// Warna permukaan yang mengikuti tema aktif.
SurfacePalette surfaceOf(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? SurfacePalette.dark
    : SurfacePalette.light;

class SurfacePalette {
  const SurfacePalette({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.text,
    required this.textSoft,
    required this.border,
    required this.shadow,
    required this.accent,
    required this.accentAlt,
    required this.success,
    required this.danger,
    required this.muted,
  });

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color text;
  final Color textSoft;
  final Color border;
  final Color shadow;
  final Color accent;
  final Color accentAlt;
  final Color success;
  final Color danger;
  final Color muted;

  static const SurfacePalette light = SurfacePalette(
    background: AppColors.bone,
    surface: AppColors.paper,
    surfaceAlt: Color(0xFFEDE7D8),
    text: AppColors.ink,
    textSoft: AppColors.inkSoft,
    border: AppColors.ink,
    shadow: AppColors.ink,
    accent: AppColors.orange,
    accentAlt: AppColors.teal,
    success: AppColors.green,
    danger: AppColors.red,
    muted: AppColors.sun,
  );

  static const SurfacePalette dark = SurfacePalette(
    background: AppColors.night,
    surface: AppColors.nightSurface,
    surfaceAlt: Color(0xFF24261B),
    text: AppColors.bone,
    textSoft: AppColors.nightSoft,
    border: AppColors.nightLine,
    shadow: Colors.black,
    accent: Color(0xFFFF7A47),
    accentAlt: AppColors.tealBright,
    success: AppColors.greenBright,
    danger: Color(0xFFF0654B),
    muted: AppColors.sun,
  );
}
