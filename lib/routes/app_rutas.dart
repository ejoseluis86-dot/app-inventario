import 'package:flutter/material.dart';
import 'package:mi_app/screens/asociar_receta_screen.dart';
import 'package:mi_app/screens/crear_pedido_screen.dart';
import 'package:mi_app/screens/home_screen.dart';
import 'package:mi_app/screens/insumos_screen.dart';
import 'package:mi_app/screens/nuevo_producto_screen.dart';

class AppRutas {
  static const String home = '/';
  static const String nuevoProducto = '/nuevo_producto';
  static const String nuevaReceta = '/nueva_receta';
  static const String crearPedido = '/crear_pedido';
  static const String insumos = '/insumos';

  static Map<String, WidgetBuilder> rutas = {
    home: (context) => const MyHomeScreen(),
    nuevoProducto: (context) => const NuevoProductoScreen(),
    nuevaReceta: (context) => const AsociarRecetaScreen(
      nombreProducto: '',
      precioProducto: 0,
      categoria: '',
    ),
    crearPedido: (context) => const CrearPedidoScreen(),
    insumos: (context) => const InsumosScreen(),
  };
}
