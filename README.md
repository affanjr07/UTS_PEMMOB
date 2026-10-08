# Nalar Nusantara — Aplikasi Kuis Pilihan Ganda

**UTS Lab Pemrograman Mobile** · Take-home, individu · Affan (`affanjr07`)

Aplikasi kuis pilihan ganda bertema pengetahuan umum Indonesia. Pengguna memasukkan
nama, mengerjakan 12 soal dari 5 kategori, lalu melihat skor akhir atas namanya
beserta pembahasan seluruh jawaban.

---

## Daftar Fitur

### Kriteria wajib

| # | Kriteria | Implementasi |
|---|----------|--------------|
| 1 | `StatelessWidget` & `StatefulWidget` sesuai kebutuhan | `WelcomeScreen` & `QuizScreen` (StatefulWidget: animasi masuk, shake validasi, lock jawaban), `ResultScreen`, `ReviewScreen`, seluruh widget tampilan (StatelessWidget) |
| 2 | Minimal 2 halaman + navigasi antar halaman | 4 halaman: **Sambutan → Kuis → Hasil → Pembahasan**, dengan `Navigator` + transisi halaman kustom (slide + fade + scale) |
| 3 | Komponen UI berulang sebagai widget terpisah (reusable) | 14 file di `lib/widgets/` — `NeoCard`, `PrimaryButton`, `SecondaryButton`, `OptionTile`, `ScoreRing`, `SegmentedProgress`, `StatTile`, `StatGrid`, `CategoryChip`, `MicroLabel`, `BrandLogo`, `MarqueeTicker`, `TimerDial`, `DecorBackground` |
| 4 | Memakai aset gambar/ikon | SVG buatan sendiri: `logo_mark.svg`, `hero_illustration.svg`, `trophy.svg`; ikon launcher PNG + adaptive icon Android/iOS; ikon Material pada tiap komponen |
| 5 | Font kustom (bukan bawaan Flutter) | **Syne** (500–800) untuk display/judul & **Space Grotesk** (400–700) untuk teks/label, di-bundle lokal di `assets/fonts/` |
| 6 | Ukuran UI dinamis (tidak hardcode) | Helper `BuildContext.fs()/sz()/gap()` di `lib/core/responsive/responsive.dart` — semua ukuran diskalakan relatif lebar layar acuan 390 px + `ContentMaxWidth` & `StatGrid` responsif |
| 7 | State management, progres tidak hilang saat rotasi/pindah halaman | `QuizController` (ChangeNotifier) + `provider`, diletakkan **di atas** `MaterialApp` sehingga rotasi layar, keluar-masuk halaman, dan `pushReplacement` tidak menghapus progres |
| 8 | Tanpa database (data lokal/dummy) | 12 soal hardcoded di `lib/core/data/quiz_bank.dart` |
| 9 | GitHub sebagai pelacak kemajuan | Commit per fitur (lihat riwayat di bawah) |
| 10 | Desain bebas, sedetail mungkin | Tema neo-editorial "bone & ink", ilustrasi SVG sendiri, animasi berlapis |

### Bonus (opsional)

| # | Bonus | Implementasi |
|---|-------|--------------|
| 1 | Dual-theme terang/gelap | `ThemeController` + `ThemeData` terang/gelap, tombol ganti tema di halaman sambutan, transisi tema 500 ms, splash screen Android menyesuaikan mode gelap |
| 2 | Adaptive & responsive | Lebar konten dibatasi di tablet (560–780 px), grid statistik berubah 1→3 kolom, skala font dibatasi `TextScaler`, diuji juga pada mode web |

### Fitur tambahan

- **Mode timer** 20 detik/soal dengan dial hitung mundur + skor bonus sisa waktu.
- **Skor berjenjang**: poin dasar, bonus waktu, streak jawaban benar beruntun.
- **Predikat hasil** (Sangat Paham → Ayo Belajar Lagi) + rekap 6 statistik.
- **Layar pembahasan**: setiap soal menampilkan kunci, jawaban user, dan catatan.
- **Resume kuis**: keluar dari halaman kuis lalu tekan "Lanjutkan" — progres tetap ada.
- **Animasi**: transisi antar soal, stagger opsi jawaban, umpan balik terkunci (pilih → benar/salah), ring skor animasi, angka skor count-up, marquee berjalan, latar melayang.

---

## Struktur Proyek

```
lib/
├── main.dart                     # registrasi provider + MaterialApp (dual theme)
├── core/
│   ├── data/quiz_bank.dart       # 12 soal dummy (5 kategori)
│   ├── navigation/app_routes.dart# transisi halaman kustom
│   ├── responsive/responsive.dart# helper ukuran dinamis (fs/sz/gap)
│   └── theme/                    # warna, tipografi, ThemeData
├── models/question.dart          # model Question, QuizResult, kategori
├── state/
│   ├── quiz_controller.dart      # state kuis (provider)
│   └── theme_controller.dart     # state tema (provider)
├── screens/                      # welcome, quiz, result, review
└── widgets/                      # 14 widget reusable
assets/
├── fonts/                        # Syne & Space Grotesk (TTF)
└── images/                       # ilustrasi SVG
icons/                            # sumber ikon launcher (PNG 512)
```

## Menjalankan

```bash
flutter pub get
flutter run                 # perangkat/emulator
flutter test                # 2 widget test alur kuis
flutter build apk --release # menghasilkan APK di build/app/outputs/flutter-apk/
```

## Riwayat Commit (pelacakan kemajuan)

1. `chore: inisialisasi proyek Flutter + konfigurasi platform (applicationId, label, ikon launcher, splash brand)`
2. `feat: font kustom Syne & Space Grotesk, aset SVG, dependensi provider/flutter_svg`
3. `feat: sistem desain — palet warna, tipografi, dual theme, transisi navigasi, helper responsif`
4. `feat: model soal, bank soal dummy, dan state management QuizController/ThemeController`
5. `feat: reusable widgets (kartu, tombol, opsi jawaban, ring skor, grid statistik, dll)`
6. `feat: halaman sambutan, kuis, hasil, dan pembahasan + registrasi provider`
7. `test: widget test alur kuis (validasi nama → 12 soal → hasil → pembahasan)`
8. `docs: README lengkap (kriteria, struktur, cara menjalankan)`
