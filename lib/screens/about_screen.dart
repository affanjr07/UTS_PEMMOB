import 'package:flutter/material.dart';

import '../core/responsive/responsive.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_type.dart';
import '../widgets/decor_background.dart';
import '../widgets/micro_label.dart';
import '../widgets/neo_card.dart';

/// Halaman kredit & informasi aplikasi.
/// Menjelaskan kriteria tugas UTS yang dipenuhi serta sumber aset.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _criteria = <String>[
    'StatelessWidget & StatefulWidget dipakai sesuai kebutuhan',
    'Minimal 2 halaman + navigasi (aplikasi kini punya 5 halaman)',
    'Widget reusable dipisah ke file sendiri di lib/widgets/',
    'Menggunakan aset gambar/ikon: ilustrasi SVG & ikon aplikasi PNG',
    'Font kustom Syne + Space Grotesk, bukan font bawaan Flutter',
    'Ukuran UI dinamis lewat helper responsif, tanpa angka mati',
    'State management (Provider): progres kuis tidak hilang saat rotasi',
    'Tanpa database — bank soal dummy tersimpan lokal di aplikasi',
  ];

  static const _credits = <String>[
    'Font: Syne & Space Grotesk dari Google Fonts (lisensi OFL)',
    'Ilustrasi SVG (logo, hero, trofi): dibuat sendiri untuk aplikasi ini',
    'Ikon aplikasi: flutter_launcher_icons (adaptive icon Android/iOS)',
    'Palet warna "neo-editorial": bone & ink dengan aksen jingga',
  ];

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);

    return Scaffold(
      body: DecorBackground(
        child: SafeArea(
          bottom: false,
          child: ContentMaxWidth(
            padding: EdgeInsets.symmetric(horizontal: context.gap(20)),
            child: ListView(
              children: [
                SizedBox(height: context.gap(14)),
                Row(
                  children: [
                    _BackButton(onTap: () => Navigator.of(context).pop()),
                    SizedBox(width: context.gap(12)),
                    MicroLabel('Tentang aplikasi', color: palette.accent),
                  ],
                ),
                SizedBox(height: context.gap(20)),
                NeoCard(
                  radius: 22,
                  shadowOffset: 6,
                  padding: EdgeInsets.all(context.gap(18)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NALAR NUSANTARA',
                        style: AppType.labelStyle(
                          fontSize: context.fs(12),
                          color: palette.text,
                          letterSpacing: 2.2,
                        ),
                      ),
                      SizedBox(height: context.gap(10)),
                      Text(
                        'Aplikasi kuis pilihan ganda berisi 12 soal pengetahuan '
                        'umum lintas kategori — budaya, sejarah, sains, teknologi, '
                        'dan geografi Nusantara. Dibuat untuk tugas UTS '
                        'Lab Pemrograman Mobile.',
                        style: AppType.bodyStyle(
                          fontSize: context.fs(13.5),
                          color: palette.textSoft,
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.gap(16)),
                NeoCard(
                  radius: 22,
                  shadowOffset: 5,
                  padding: EdgeInsets.all(context.gap(18)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MicroLabel('Kriteria tugas UTS', color: palette.accent),
                      SizedBox(height: context.gap(14)),
                      for (final item in _criteria)
                        _ChecklistItem(text: item, color: palette.success),
                    ],
                  ),
                ),
                SizedBox(height: context.gap(16)),
                NeoCard(
                  radius: 22,
                  shadowOffset: 5,
                  padding: EdgeInsets.all(context.gap(18)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MicroLabel(
                        'Kredit & sumber daya',
                        color: palette.accentAlt,
                      ),
                      SizedBox(height: context.gap(14)),
                      for (final item in _credits)
                        _ChecklistItem(text: item, color: palette.accentAlt),
                    ],
                  ),
                ),
                SizedBox(height: context.gap(24)),
                Center(
                  child: Text(
                    'Dibuat dengan Flutter • v1.0.0',
                    style: AppType.labelStyle(
                      fontSize: context.fs(10.5),
                      color: palette.textSoft,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: context.gap(24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.sz(42),
        height: context.sz(42),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: palette.surface,
          shape: BoxShape.circle,
          border: Border.all(color: palette.border, width: context.sz(1.6)),
          boxShadow: [
            BoxShadow(
              color: palette.shadow,
              offset: Offset(context.sz(3), context.sz(3)),
              blurRadius: 0,
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          size: context.sz(20),
          color: palette.text,
        ),
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    return Padding(
      padding: EdgeInsets.only(bottom: context.gap(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded, size: context.sz(17), color: color),
          SizedBox(width: context.gap(9)),
          Expanded(
            child: Text(
              text,
              style: AppType.bodyStyle(
                fontSize: context.fs(13),
                color: palette.text,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
