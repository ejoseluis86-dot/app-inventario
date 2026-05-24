import 'package:flutter/material.dart';
import 'package:mi_app/theme/app_themes.dart';
import 'screens/home_screen.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const MyHomeScreen(),
    );
  }
}
