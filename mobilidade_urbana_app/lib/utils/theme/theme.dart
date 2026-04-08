import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/theme/custom_themes/text_theme.dart';
import 'package:mobilidade_urbana_app/utils/theme/controllers/theme.controller.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme(double scale) => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: Colors.lightGreen,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.lightTextTheme(scale),
    elevatedButtonTheme: ElevatedButtonThemeData()
  );
  static ThemeData darkTheme(double scale) => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: Colors.lightGreen,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TTextTheme.darkTextTheme(scale),
  );
}