import 'package:flutter/material.dart';
import 'package:mind_lab_app/core/theme/app_pallete.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(
          8,
        ),
      );
  static final darkThemeMode = ThemeData.dark();
  static final lightThemeMode = ThemeData.light(useMaterial3: false).copyWith(
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.gradient2),
    ),
  );
}
