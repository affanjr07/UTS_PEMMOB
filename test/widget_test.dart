import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uts_affan/core/data/quiz_bank.dart';
import 'package:uts_affan/main.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const NalarNusantaraApp());
    await tester.pump(const Duration(milliseconds: 1300));
  }

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pump(const Duration(milliseconds: 350));
    await tester.tap(finder);
    await tester.pump();
  }

  testWidgets('validasi nama kosong lalu memulai kuis', (tester) async {
    await pumpApp(tester);

    expect(find.textContaining('Seberapa'), findsOneWidget);

    await tapVisible(tester, find.textContaining('MULAI KUIS'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.textContaining('minimal 2 karakter'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Affan');
    await tester.pump(const Duration(milliseconds: 200));
    await tapVisible(tester, find.textContaining('MULAI KUIS'));
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.textContaining('SOAL 1 DARI 12'), findsOneWidget);
  });

  testWidgets('menjawab semua soal dan melihat hasil + pembahasan', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.enterText(find.byType(TextField), 'Affan');
    await tester.pump(const Duration(milliseconds: 150));
    await tapVisible(tester, find.textContaining('MULAI KUIS'));
    await tester.pump(const Duration(milliseconds: 700));

    final questions = QuizBank.questions;
    for (var i = 0; i < questions.length; i++) {
      final q = questions[i];
      final option = find.text(q.options[q.correctIndex]).first;
      await tester.ensureVisible(option);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(option);
      await tester.pump(const Duration(milliseconds: 700));

      final label = i == questions.length - 1
          ? 'LIHAT HASIL'
          : 'SOAL BERIKUTNYA';
      expect(find.text(label), findsOneWidget);
      await tapVisible(tester, find.text(label));
      await tester.pump(const Duration(milliseconds: 750));
    }

    expect(find.textContaining('Halo, Affan!'), findsOneWidget);
    expect(find.textContaining('12 dari 12 benar'), findsOneWidget);

    await tapVisible(tester, find.text('LIHAT PEMBAHASAN'));
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.textContaining('PEMBAHASAN'), findsOneWidget);
    expect(find.textContaining('SOAL 01'), findsOneWidget);
  });

  testWidgets('mengganti tema dari terang ke gelap dan kembali', (tester) async {
    await pumpApp(tester);

    expect(find.byIcon(Icons.wb_sunny_rounded), findsOneWidget);
    await tapVisible(tester, find.byIcon(Icons.wb_sunny_rounded));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byIcon(Icons.nightlight_round), findsOneWidget);

    await tapVisible(tester, find.byIcon(Icons.nightlight_round));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byIcon(Icons.wb_sunny_rounded), findsOneWidget);
  });

  testWidgets('keluar dari kuis lalu melanjutkan dari soal terakhir', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.enterText(find.byType(TextField), 'Affan');
    await tester.pump(const Duration(milliseconds: 150));
    await tapVisible(tester, find.textContaining('MULAI KUIS'));
    await tester.pump(const Duration(milliseconds: 700));

    // Jawab soal pertama lalu lanjut ke soal kedua.
    final q = QuizBank.questions.first;
    final option = find.text(q.options[q.correctIndex]).first;
    await tester.ensureVisible(option);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(option);
    await tester.pump(const Duration(milliseconds: 700));
    await tapVisible(tester, find.text('SOAL BERIKUTNYA'));
    await tester.pump(const Duration(milliseconds: 750));

    // Kembali ke halaman sambutan dan konfirmasi keluar.
    await tapVisible(tester, find.byIcon(Icons.arrow_back_rounded));
    await tester.pump(const Duration(milliseconds: 450));
    expect(find.textContaining('Keluar dari kuis?'), findsOneWidget);

    await tapVisible(tester, find.textContaining('KELUAR'));
    await tester.pump(const Duration(milliseconds: 750));

    // Progres tersimpan: sambutan menawarkan kelanjutan kuis.
    expect(find.textContaining('LANJUTKAN (1/12)'), findsOneWidget);
    await tapVisible(tester, find.textContaining('LANJUTKAN'));
    await tester.pump(const Duration(milliseconds: 750));

    expect(find.textContaining('SOAL 2 DARI 12'), findsOneWidget);
  });
}
