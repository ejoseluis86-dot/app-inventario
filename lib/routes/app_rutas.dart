import 'package:flutter/material.dart';
import 'package:mi_app/screens/asociar_receta_screen.dart';
import 'package:mi_app/screens/home_screen.dart';
import 'package:mi_app/screens/nuevo_producto_screen.dart';

class AppRutas {
  static const String home = '/';
  static const String nuevoProducto = '/nuevo_producto';
  static const String nuevaReceta = '/nueva_receta';

  static Map<String, WidgetBuilder> rutas = {
    home: (context) => const MyHomeScreen(),
    nuevoProducto: (context) => const NuevoProductoScreen(),
    nuevaReceta: (context) => const AsociarRecetaScreen(nombreProducto: ''),
  };
}
