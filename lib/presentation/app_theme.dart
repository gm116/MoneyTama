import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme(bool isDark) {
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final theme = ThemeData(
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFF59008C), // todo: выбрать цвета
        secondary: Color(0xFF94EBFF),
        brightness: brightness,
      ),
    );
    return theme;
  }
}
