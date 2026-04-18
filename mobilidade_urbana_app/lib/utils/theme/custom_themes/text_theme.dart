import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/constants/text_sizes.dart';


class TTextTheme {
  TTextTheme._();



  static TextTheme lightTextTheme(double scale) => TextTheme(
    headlineLarge: TextStyle(
      fontSize: TTextSizes.headlineLarge * scale,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'Poppins',
    ),
    headlineMedium: TextStyle(
      fontSize: TTextSizes.headlineMedium * scale,
      fontWeight: FontWeight.w700,
      color: Colors.black,
      fontFamily: 'Poppins',
    ),
    titleLarge:  TextStyle(
      fontSize: TTextSizes.titleLarge * scale,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      fontFamily: 'Poppins',
    ),
    titleMedium:  TextStyle(
      fontSize: TTextSizes.titleMedium * scale,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
      fontFamily: 'Poppins',
    ),
    bodyLarge:  TextStyle(
      fontSize: TTextSizes.bodyLarge * scale,
      fontWeight: FontWeight.w400,
      color: Colors.black87,
      fontFamily: 'Inter',
    ),
    bodyMedium:  TextStyle(
      fontSize: TTextSizes.bodyMedium * scale,
      fontWeight: FontWeight.w400,
      color: Colors.black87,
      fontFamily: 'Inter',
    ),
    bodySmall:  TextStyle(
      fontSize: TTextSizes.bodySmall * scale,
      fontWeight: FontWeight.w400,
      color: Colors.black54,
      fontFamily: 'Inter',
    ),
  );

  static TextTheme darkTextTheme(double scale) => TextTheme(
    headlineLarge: TextStyle(
      fontSize: TTextSizes.headlineLarge * scale,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'Poppins',
    ),
    headlineMedium: TextStyle(
      fontSize: TTextSizes.headlineMedium * scale,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      fontFamily: 'Poppins',
    ),
    titleLarge: TextStyle(
      fontSize: TTextSizes.titleLarge * scale,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      fontFamily: 'Poppins',
    ),
    titleMedium: TextStyle(
      fontSize: TTextSizes.titleMedium * scale,
      fontWeight: FontWeight.w500,
      color: Colors.white70,
      fontFamily: 'Poppins',
    ),
    bodyLarge: TextStyle(
      fontSize: TTextSizes.bodyLarge * scale,
      fontWeight: FontWeight.w400,
      color: Colors.white70,
      fontFamily: 'Inter',
    ),
    bodyMedium: TextStyle(
      fontSize: TTextSizes.bodyMedium * scale,
      fontWeight: FontWeight.w400,
      color: Colors.white70,
      fontFamily: 'Inter',
    ),
    bodySmall: TextStyle(
      fontSize: TTextSizes.bodySmall * scale,
      fontWeight: FontWeight.w400,
      color: Colors.white60,
      fontFamily: 'Inter',
    ),
    labelLarge: TextStyle(
      fontSize: TTextSizes.bodySmall * scale,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      fontFamily: 'Inter',
    ),
  );
}