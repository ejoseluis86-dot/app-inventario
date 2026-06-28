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
      error = null;
      notifyListeners();

      final data = await api.obtenerProductosLite();

      productosLite =
          data.map((e) => ProductoLite.fromJson(e)).toList();

    } catch (e) {
      error = e.toString();
      productosLite = [];
      print("❌ ERROR PRODUCTOS: $e");

    } finally {
      loading = false;
      notifyListeners();
    }
  }
}