import 'package:flutter/material.dart';

/// State management untuk dual-theme (terang/gelap).
class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  bool _useSystem = false;

  ThemeMode get mode => _mode;
  bool get useSystem => _useSystem;
  bool get isDark => _mode == ThemeMode.dark;

  void toggle() {
    if (_useSystem) {
      _useSystem = false;
      _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    } else {
      _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
  }

  void setUseSystem(bool value) {
    _useSystem = value;
    _mode = value ? ThemeMode.system : ThemeMode.light;
    notifyListeners();
  }
}
