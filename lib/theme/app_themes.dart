import 'package:flutter/material.dart';

class AppTheme {

  //MODO CLARO
  static final light = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF592DA5),
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor: const Color.fromARGB(255, 243, 235, 254),
  );


  //MODO OSCURO
  static final dark = ThemeData(
  useMaterial3: true,

  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF5B2DA5),
    brightness: Brightness.dark,
  ),

  scaffoldBackgroundColor: const Color(0xFF121212),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1A1A1A),
    foregroundColor: Colors.white,
  ),

  cardTheme: const CardThemeData(
    color: Color(0xFF1E1E1E),
  ),
);
}