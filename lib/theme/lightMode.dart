import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade100,
    primary: Colors.green.shade600,
    secondary: Colors.white,
    tertiary: Colors.grey.shade200,
    inversePrimary: Colors.grey.shade900,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
    titleLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
  ),
);
