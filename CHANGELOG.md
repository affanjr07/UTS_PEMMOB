# Changelog

Semua perubahan penting pada proyek **Nalar Nusantara** dicatat di sini.
Format mengikuti [Keep a Changelog](https://keepachangelog.com/).

## [1.0.0] — 2026-10-21

Rilis pertama untuk tugas UTS Lab Pemrograman Mobile.

### Ditambahkan

- Kuis pilihan ganda 12 soal dummy lintas 5 kategori (Budaya, Sejarah, Sains, Teknologi, Geografi) — tanpa database.
- 5 halaman bernavigasi: Sambutan, Kuis, Hasil, Pembahasan, dan Tentang (kriteria UTS & kredit aset).
- State management `provider` (`QuizController`, `ThemeController`, `ScoreStore`, `PrefsStore`) di atas `MaterialApp` agar progres kuis tidak hilang saat rotasi atau pindah halaman; fitur resume kuis.
- Pemilih kategori soal serta opsi acak urutan soal di halaman sambutan.
- Mode timer 20 detik per soal dengan dial hitung mundur dan skor bonus sisa waktu; streak jawaban benar beruntun.
- Layar hasil: ring skor animasi, count-up angka, rekap 6 statistik, predikat, konfeti, dan tombol salin hasil ke papan klip.
- Rekor tertinggi + 5 skor terakhir tersimpan lokal (`shared_preferences`), chip "rekor baru!" saat memecahkan rekor.
- Preferensi mode timer & acak soal yang bertahan antar sesi.
- Umpan balik haptic saat menjawab, mulai kuis, dan tiba di layar hasil.
- Tema ganda terang/gelap ("neo-editorial bone & ink") dengan tombol ganti tema dan splash screen Android adaptif.
- Font kustom Syne & Space Grotesk (Google Fonts), ilustrasi SVG buatan sendiri, ikon launcher adaptive Android/iOS.
- Tampilan adaptive & responsive (tablet/web): lebar konten maksimum, grid statistik 1→3 kolom, skala font dibatasi.
- 15 widget reusable di `lib/widgets/`.

### Pengujian

- 4 widget test: validasi nama, alur kuis penuh → hasil → pembahasan, ganti tema, resume kuis.
- 7 unit test `QuizController`: status awal, skor & streak, bonus waktu, akurasi hasil akhir, filter kategori, acak soal, restart.
- 4 unit test `ScoreStore`: pemuatan, pemutakhiran rekor, persistensi, idempotensi.

### Teknis

- `flutter analyze`: 0 issue · `flutter test`: 15 pengujian lolos · `flutter build apk --release` sukses.
- 22 commit per fitur di GitHub sebagai pelacakan kemajuan.
