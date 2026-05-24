import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurpleAccent,
      brightness: Brightness.light,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorScheme.fromSeed(
        seedColor: Colors.deepPurpleAccent,
      ).primary,
    ),
    useMaterial3: true,
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurpleAccent,
      brightness: Brightness.dark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorScheme.fromSeed(
        seedColor: Colors.deepPurpleAccent,
      ).primary,
    ),
    useMaterial3: true,
  );
}
