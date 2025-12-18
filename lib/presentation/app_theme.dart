import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF181818),
    scaffoldBackgroundColor: const Color(0xFF181818),
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFFF6D14C),
      secondary: const Color(0xFFF6D14C),
      surface: const Color(0xFF181818),
      background: const Color(0xFF181818),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF181818),
      foregroundColor: Color(0xFFF6D14C),
    ),
  );
}
