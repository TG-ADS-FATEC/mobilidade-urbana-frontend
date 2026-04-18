import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  double _fontScale = 1.0;

  double get fontScale => _fontScale;

  void updateFontScale(double value) {
    _fontScale = value;
    notifyListeners();
  }

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}