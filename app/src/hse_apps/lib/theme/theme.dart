import 'package:flutter/material.dart';

ThemeData LightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Colors.white
  ),
);

ThemeData DarkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.black
  ),
);

//secondary text colors
Color secondary_text_color = Colors.grey[600]!;
Color secondary_text_color_dark = Colors.grey[400]!;

//primary text colors
Color primary_text_color = Colors.black;
Color primary_text_color_dark = Colors.white;

Color secondary_Border_color_dark = Colors.grey[800]!;
Color secondary_Border_color = Colors.grey[400]!;