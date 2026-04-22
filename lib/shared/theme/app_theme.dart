import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0D0D12),

    primaryColor: const Color(0xFF7C6FFF),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white70),
      bodyLarge: TextStyle(color: Colors.white),
    ),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF7C6FFF),

      surface: Color(0xFF0D0D12),
    ),
  );
}