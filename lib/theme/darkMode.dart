import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: const Color(0xFF121212),
    primary: Colors.green.shade500,
    secondary: const Color(0xFF1E1E1E),
    tertiary: const Color(0xFF2C2C2C),
    inversePrimary: Colors.grey.shade300,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white),
    titleLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
  ),
);
