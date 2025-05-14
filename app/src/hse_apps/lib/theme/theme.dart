import 'package:flutter/material.dart';

ThemeData LightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Colors.white
  ),
  fontFamily: 'apple',
);

ThemeData DarkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Colors.black
  ),
  fontFamily: 'apple',
  
);

//secondary text colors
Color secondary_text_color = Colors.grey[600]!;
Color secondary_text_color_dark = Colors.grey[400]!;

//primary text colors
Color primary_text_color = Colors.black;
Color primary_text_color_dark = Colors.white;

Color secondary_Border_color_dark = Colors.grey[800]!;
Color secondary_Border_color = Colors.grey[400]!;

//other text colors
Color opaque_white_text = Colors.white.withOpacity(.5);

//main color
Color main_color = Colors.blueAccent;
// Color main_color = Colors.redAccent;
Color main_color_dark = Colors.black;

Color main_container_color_dark = const Color.fromARGB(255, 15, 15, 15);