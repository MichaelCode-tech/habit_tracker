import 'package:flutter/material.dart';
import 'package:habit_tracker/DB/DB.dart';
import 'package:habit_tracker/theme/darkMode.dart';
import 'package:habit_tracker/theme/lightMode.dart';

class ThemeProvider extends ChangeNotifier {
  // initial theme is light mode
  ThemeData _themeData = lightMode;

  // Constructor can take initial theme
  ThemeProvider(bool isDarkMode) {
    _themeData = isDarkMode ? darkMode : lightMode;
  }

  // get current theme
  ThemeData get themeData => _themeData;

  // is current theme dark mode
  bool get isDarkMode => _themeData == darkMode;

  // set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
      HabitDB().updateIsDarkMode(true);
    } else {
      themeData = lightMode;
      HabitDB().updateIsDarkMode(false);
    }
  }
}
