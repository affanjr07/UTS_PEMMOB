import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Penyimpan skor sederhana (lokal, tanpa database).
/// Menyimpan skor tertinggi + 5 skor terakhir agar tampil di halaman sambutan.
class ScoreStore extends ChangeNotifier {
  static const _kBest = 'best_score';
  static const _kRecent = 'recent_scores';

  int bestScore = 0;
  List<int> recentScores = [];
  bool _loaded = false;
  String _lastRecordedKey = '';

  bool get loaded => _loaded;
  int get lastScore => recentScores.isEmpty ? 0 : recentScores.first;

  ScoreStore() {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bestScore = prefs.getInt(_kBest) ?? 0;
      recentScores = (prefs.getStringList(_kRecent) ?? const [])
          .map((e) => int.tryParse(e) ?? 0)
          .toList();
    } catch (_) {
      // Penyimpanan tidak tersedia (mis. web privat) — abaikan, tetap jalan.
      bestScore = 0;
      recentScores = [];
    }
    _loaded = true;
    notifyListeners();
  }

  /// Benarkah skor ini memecahkan rekor sebelumnya?
  bool isNewRecord(int score) => _loaded && score > bestScore;

  /// Catat hasil kuis. Idempoten: hasil identik tidak dicatat dua kali.
  Future<void> record({
    required int score,
    required String name,
    required int correct,
    required int total,
  }) async {
    final key = '$score|$name|$correct|$total';
    if (!_loaded || key == _lastRecordedKey) return;
    _lastRecordedKey = key;

    final newBest = score > bestScore;
    if (newBest) bestScore = score;
    recentScores = ([score] + recentScores).take(5).toList();
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kBest, bestScore);
      await prefs.setStringList(
        _kRecent,
        recentScores.map((e) => '$e').toList(),
      );
    } catch (_) {
      // Gagal menyimpan tidak mengganggu alur aplikasi.
    }
  }
}
