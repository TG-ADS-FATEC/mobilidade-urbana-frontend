import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/theme/custom_themes/text_theme.dart';
import 'package:mobilidade_urbana_app/utils/theme/custom_themes/appbar_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme(double scale) => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: TColors.soothingLime,
    scaffoldBackgroundColor: TColors.background,
    textTheme: TTextTheme.lightTextTheme(scale),
    elevatedButtonTheme: ElevatedButtonThemeData(),
    appBarTheme: TAppBarTheme.lightAppBarTheme,
  );
  static ThemeData darkTheme(double scale) => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: TColors.soothingLime,
    scaffoldBackgroundColor: TColors.darkBackground,
    textTheme: TTextTheme.darkTextTheme(scale),
    appBarTheme: TAppBarTheme.darkAppBarTheme,

  );
}