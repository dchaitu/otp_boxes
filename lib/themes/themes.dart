import 'package:flutter/material.dart';
import 'package:otp_boxes/constants/colors.dart';

final ThemeData lightTheme = ThemeData(
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
        bodyMedium:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)));


final ThemeData darkTheme = ThemeData(
    primaryColorLight: darkThemeLightShade,
    primaryColorDark: darkThemeDarkShade,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    ),
    scaffoldBackgroundColor: Colors.black,
    dividerColor: darkThemeLightShade,
    textTheme: const TextTheme().copyWith(
        bodyMedium:
        const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)));