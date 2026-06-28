import 'package:flutter/material.dart';
import 'package:mi_app/providers/insumos_provider.dart';
import 'package:mi_app/providers/pedido_lite_provider.dart';
import 'package:mi_app/providers/producto_lite_provider.dart';
import 'package:mi_app/providers/user_provider.dart';
import 'package:mi_app/routes/app_rutas.dart';
import 'package:mi_app/theme/app_themes.dart';
import 'package:provider/provider.dart';

import 'services/api_service.dart';


void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => InsumoProvider()),
      ChangeNotifierProvider(create: (_) => ProductoLiteProvider()),
      ChangeNotifierProvider(create: (_) => PedidoLiteProvider()),

      Provider<ApiService>(
        create: (_) => ApiService(),
      ),
    ],
    child: const MainApp(),
  ),
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: AppRutas.login,
      routes: AppRutas.rutas,
    );
  }
}
