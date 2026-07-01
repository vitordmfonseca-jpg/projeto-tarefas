import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: Color(0xFF0F1117),
      surfaceContainer: Color(0xFF1A1D27),
      primary: Color(0xFF7C6EF5),
      onPrimary: Colors.white,
    ),
    fontFamily: 'Inter',
    cardTheme: CardThemeData(
      color: Color(0xFF1A1D27),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Color(0xFF1A1D27),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
