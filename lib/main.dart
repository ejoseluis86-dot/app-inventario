import 'package:flutter/material.dart';
import 'package:mi_app/providers/insumos_provider.dart';
import 'package:mi_app/providers/user_provider.dart';
import 'package:mi_app/routes/app_rutas.dart';
import 'package:mi_app/theme/app_themes.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => InsumoProvider()),
    ],
    child: const MainApp(),
  ),
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRutas.login,
      routes: AppRutas.rutas,
    );
  }
}
