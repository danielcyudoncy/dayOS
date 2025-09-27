// core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:day_os/core/theme/font_util.dart';

class AppTheme {
  static const _defaultGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1a1a2e), // Dark background
      Color(0xFF8B5CF6), // Purple
    ],
  );

  static final lightTheme = ThemeData(
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: const Color(0xFF1a1a2e),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1a1a2e),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    fontFamily: FontUtil.fontFamily,
    textTheme: FontUtil.getTextTheme(color: Colors.white),
    cardColor: Colors.white.withValues(alpha: 0.1),
    dialogTheme: const DialogThemeData(
      backgroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );

  static BoxDecoration get backgroundDecoration => const BoxDecoration(
    gradient: _defaultGradient,
  );
}
