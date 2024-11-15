import 'package:flutter/material.dart';

class ThemeDataStyle {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.green,
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Colors.blueGrey,
      secondary: Colors.teal,
    ),
  );
}