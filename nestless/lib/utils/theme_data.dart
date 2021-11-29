import 'package:flutter/material.dart';
import 'package:nestless/utils/config.dart';

class AppThemeData with ChangeNotifier {
  static bool _isDark = false;

  static bool get isDark => _isDark;

  AppThemeData() {
    // Initializing the dark mode on/off in Hive
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
    // Toggle the dark mode
    _isDark = !_isDark;
    // Update the Hive
    box!.put('setTheme', _isDark);
    // Notify the listeners
    notifyListeners();
  }
}
