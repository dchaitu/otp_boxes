import 'package:flutter/material.dart';
import 'package:otp_boxes/constants/colors.dart';

class AppColors {
  static const Color hintTextLight = Colors.black54;
  static const Color hintTextDark = Colors.white54;
  static const Color iconLight = Colors.black54;
  static const Color iconDark = Colors.white54;
}

final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.black,
    primaryColorLight: lightThemeLightShade,
    primaryColorDark: lightThemeDarkShade,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
          color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme().copyWith(
      bodyMedium: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: AppColors.hintTextLight),
      prefixIconColor: AppColors.iconLight,
      suffixIconColor: AppColors.iconLight,
      labelStyle: TextStyle(color: AppColors.iconLight),
      floatingLabelStyle: TextStyle(color: AppColors.iconLight),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.iconLight,
    ));

final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.white,
    primaryColorLight: darkThemeLightShade,
    primaryColorDark: darkThemeDarkShade,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    ),
    scaffoldBackgroundColor: Colors.black,
    dividerColor: darkThemeLightShade,
    textTheme: const TextTheme().copyWith(
      bodyMedium: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: AppColors.hintTextDark),
      prefixIconColor: AppColors.iconDark,
      suffixIconColor: AppColors.iconDark,
      labelStyle: TextStyle(color: AppColors.iconDark),
      floatingLabelStyle: TextStyle(color: AppColors.iconDark),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.iconDark,
    ));