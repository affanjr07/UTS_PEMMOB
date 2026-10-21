import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uts_affan/state/score_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('memuat skor terbaik & riwayat dari penyimpanan lokal', () async {
    SharedPreferences.setMockInitialValues({
      'best_score': 500,
      'recent_scores': ['500', '300'],
    });
    final store = ScoreStore();
    await store.ready;

    expect(store.bestScore, 500);
    expect(store.recentScores, [500, 300]);
    expect(store.lastScore, 500);
    expect(store.isNewRecord(400), isFalse);
    expect(store.isNewRecord(600), isTrue);
  });

  test('record memperbarui rekor, riwayat, dan persist ke disk', () async {
    SharedPreferences.setMockInitialValues({
      'best_score': 400,
      'recent_scores': ['400'],
    });
    final store = ScoreStore();
    await store.ready;

    await store.record(score: 450, name: 'Affan', correct: 9, total: 12);

    expect(store.bestScore, 450);
    expect(store.recentScores.first, 450);
    expect(store.recentScores.length, 2);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('best_score'), 450);
    expect(prefs.getStringList('recent_scores'), ['450', '400']);
  });

  test('hasil identik tidak dicatat dua kali', () async {
    SharedPreferences.setMockInitialValues({});
    final store = ScoreStore();
    await store.ready;

    await store.record(score: 800, name: 'Ayu', correct: 10, total: 12);
    await store.record(score: 800, name: 'Ayu', correct: 10, total: 12);

    expect(store.recentScores, [800]);
  });

  test('penyimpanan kosong dimulai dari nol tanpa error', () async {
    SharedPreferences.setMockInitialValues({});
    final store = ScoreStore();
    await store.ready;

    expect(store.bestScore, 0);
    expect(store.recentScores, isEmpty);
    expect(store.lastScore, 0);
  });
}
