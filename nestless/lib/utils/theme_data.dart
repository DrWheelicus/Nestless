import 'package:flutter/material.dart';
import 'package:nestless/utils/config.dart';

class AppThemeData with ChangeNotifier {
  static bool _isDark = false;

  static bool get isDark => _isDark;

  AppThemeData() {
    if (box!.containsKey('setTheme')) {
      _isDark = box!.get('setTheme');
    } else {
      box!.put('setTheme', _isDark);
    }
  }

  ThemeMode setTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    _isDark = !_isDark;
    box!.put('setTheme', _isDark);
    notifyListeners();
  }
}
