// core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:day_os/core/theme/font_util.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: Colors.grey[50],
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.indigo,
      elevation: 0,
    ),
    fontFamily: FontUtil.fontFamily,
    textTheme: FontUtil.getTextTheme(),
  );
}
