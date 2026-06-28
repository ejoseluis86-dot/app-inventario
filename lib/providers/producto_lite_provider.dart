import 'package:flutter/material.dart';
import 'package:mi_app/models/producto_lite.dart';
import 'package:mi_app/services/api_service.dart';

class ProductoLiteProvider extends ChangeNotifier {
  List<ProductoLite> productosLite = [];
  bool loading = false;
  String? error;

  final ApiService api = ApiService();

  Future<void> cargarProviderProductos() async {
    try {
      loading = true;
      notifyListeners();

      final data = await api.obtenerProductosLite();

      productosLite = data.map((e) {
        return ProductoLite.fromJson(e);
      }).toList();

      // 🔥 IMPORTANTE: forzar rebuild limpio
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