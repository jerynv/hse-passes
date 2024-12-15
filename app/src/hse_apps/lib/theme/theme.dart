import 'package:flutter/material.dart';

ThemeData LightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Colors.white
  ),
);

ThemeData DarkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Colors.black
  ),
);

