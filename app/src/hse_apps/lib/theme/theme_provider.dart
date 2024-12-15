import 'package:flutter/material.dart';
import 'package:hse_apps/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = LightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = _themeData == LightMode ? DarkMode : LightMode;
    notifyListeners();
  }
}
