import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Preferensi pengguna (mode timer & acak soal) yang bertahan antar sesi.
/// Penyimpanan lokal sederhana — tanpa database.
class PrefsStore extends ChangeNotifier {
  static const _kTimer = 'pref_use_timer';
  static const _kShuffle = 'pref_shuffle';

  bool _useTimer = true;
  bool _shuffle = false;
  bool _loaded = false;

  bool get useTimer => _useTimer;
  bool get shuffle => _shuffle;
  bool get loaded => _loaded;

  /// Selesai memuat preferensi dari disk (dipakai pengujian).
  late final Future<void> ready;

  PrefsStore() {
    ready = _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _useTimer = prefs.getBool(_kTimer) ?? true;
      _shuffle = prefs.getBool(_kShuffle) ?? false;
    } catch (_) {
      // Gagal memuat: tetap pakai default.
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> setUseTimer(bool value) async {
    if (_useTimer == value) return;
    _useTimer = value;
    notifyListeners();
    await _persist();
  }

  Future<void> setShuffle(bool value) async {
    if (_shuffle == value) return;
    _shuffle = value;
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kTimer, _useTimer);
      await prefs.setBool(_kShuffle, _shuffle);
    } catch (_) {
      // Penyimpanan tidak tersedia — abaikan.
    }
  }
}
