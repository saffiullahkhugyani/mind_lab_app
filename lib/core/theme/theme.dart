import 'package:flutter/material.dart';
import 'package:mind_lab_app/core/theme/app_pallete.dart';
import 'package:mind_lab_app/core/theme/theme_data.dart';

class AppTheme {
  static const MaterialColor primaryBlack = MaterialColor(
    _blackPrimaryValue,
    <int, Color>{
      50: Color(0xFF2F384C),
      100: Color(0xFF2F384C),
      200: Color(0xFF2F384C),
      300: Color(0xFF2F384C),
      400: Color(0xFF2F384C),
      500: Color(_blackPrimaryValue),
      600: Color(0xFF2F384C),
      700: Color(0xFF2F384C),
      800: Color(0xFF2F384C),
      900: Color(0xFF2F384C),
    },
  );
  static const int _blackPrimaryValue = 0xFF2F384C;
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
  static final lightThemeMode =
      ThemeData(useMaterial3: false, primarySwatch: primaryBlack).copyWith(
    inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(20),
        enabledBorder: _border(),
        focusedBorder: _border(blueGrey),
        errorBorder: _border(AppPallete.errorColor)),
  );
}
