import 'package:fe_app/utils/theme/widget_theme/text_theme.dart';
import 'package:flutter/material.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(primary: Color.fromARGB(255, 224, 224, 224)),
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(elevation: 0),
    textTheme: TTextTheme.ligthTextTheme,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Color.fromARGB(255, 52, 146, 76)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
          backgroundColor: Colors.blueGrey[800],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          textStyle: const TextStyle(fontSize: 18)),
    ),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: Colors.grey[800], textStyle: const TextStyle(decoration: TextDecoration.underline))),
  );
  static ThemeData dartkTheme = ThemeData(brightness: Brightness.dark, textTheme: TTextTheme.darkTextTheme);
}
