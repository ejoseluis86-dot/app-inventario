import 'package:flutter/material.dart';
import 'package:mi_app/models/producto_lite.dart';
import 'package:mi_app/services/api_service.dart';

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

      final data = esAdmin
          ? await api.obtenerProductosAdmin()
          : await api.obtenerProductosLite();

      productosLite = data
          .map((e) => ProductoLite.fromJson(e))
          .toList();

      // 🔥 fuerza rebuild limpio
      productosLite = List.from(productosLite);

    } catch (e) {
      error = e.toString();
      productosLite = [];
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}