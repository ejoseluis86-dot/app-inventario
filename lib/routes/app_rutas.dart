import 'package:flutter/material.dart';
import 'package:mi_app/screens/asociar_receta_screen.dart';
import 'package:mi_app/screens/crear_pedido_screen.dart';
import 'package:mi_app/screens/crear_usuario_screen.dart';
import 'package:mi_app/screens/home_screen.dart';
import 'package:mi_app/screens/insumos_screen.dart';
import 'package:mi_app/screens/login_screen.dart';
import 'package:mi_app/screens/nuevo_producto_screen.dart';
import 'package:mi_app/screens/trabajo_pedidos_screen.dart';
import 'package:mi_app/screens/perfil_screen.dart';
import 'package:mi_app/screens/productos_screen.dart';


class AppRutas {
  static const String home = '/';
  static const productos = '/productos';
  static const String nuevoProducto = '/nuevo_producto';
  static const String nuevaReceta = '/nueva_receta';
  static const String crearPedido = '/crear_pedido';
  static const String insumos = '/insumos';
  static const String trabajo = '/trabajo';
  static const String login = '/login';
  static const String crearUsuario = '/crearUsuario';
  static const perfil = '/perfil';

  static Map<String, WidgetBuilder> rutas = {
    home: (context) => const MyHomeScreen(),
    productos: (context) => const ProductosScreen(),
    nuevoProducto: (context) => const NuevoProductoScreen(),
    nuevaReceta: (context) => const AsociarRecetaScreen(
      nombreProducto: '',
      precioProducto: 0,
      categoria: '',
    ),
    crearPedido: (context) => const CrearPedidoScreen(),
    insumos: (context) => const InsumosScreen(),
    trabajo: (context) => const TrabajoPedidosScreen(),
    login: (context) => const LoginScreen(),
    crearUsuario: (context) => const CrearUsuarioScreen(),
    perfil: (context) => const PerfilScreen(),
  };
}
