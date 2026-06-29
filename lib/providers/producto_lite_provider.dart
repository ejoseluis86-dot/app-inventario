import 'package:flutter/material.dart';
import 'package:mi_app/models/producto_lite.dart';
import 'package:mi_app/services/api_service.dart';
import 'package:mi_app/models/producto.dart'; // 👈 Importante para reconocer el modelo de la API

class ProductoLiteProvider extends ChangeNotifier {
  List<ProductoLite> productosLite = [];
  bool loading = false;
  String? error;

  final ApiService api = ApiService();

  Future<void> cargarProviderProductos(bool esAdmin) async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      // 1. ApiService ya nos devuelve un List<Producto> mapeado internamente
      final List<Producto> data = esAdmin
          ? await api.obtenerProductosAdmin()
          : await api.obtenerProductosLite();
      
      // 2. Transformamos cada objeto 'Producto' al molde liviano 'ProductoLite'
      productosLite = data.map((productoCompleto) {
        return ProductoLite(
          id: productoCompleto.id,
          nombre: productoCompleto.nombre,
          precio: productoCompleto.precio,
          categoria: productoCompleto.categoria,
          activo: productoCompleto.activo,
        );
      }).toList();

      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      error = e.toString();
      print("❌ ERROR EN PRODUCTO_LITE_PROVIDER: $e");
      notifyListeners();
    }
  }
}