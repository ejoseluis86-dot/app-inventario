import 'package:flutter/material.dart';
import 'package:mi_app/models/producto_lite.dart';
import 'package:mi_app/services/api_service.dart';
import 'package:mi_app/models/producto.dart';

class ProductoLiteProvider extends ChangeNotifier {
  List<ProductoLite> productosLite = [];
  bool loading = false;
  String? error;

  final ApiService api = ApiService();

  Future<void> cargarProviderProductos(bool esAdmin) async {
    try {
      final api = ApiService();

      final data = esAdmin
          ? await api.obtenerProductosAdmin()
          : await api.obtenerProductosLite();
      
      productosLite = (data as List)
        .map((e) => ProductoLite.fromJson(
              e as Map<String, dynamic>,
            ))
        .toList();

      notifyListeners();
    } catch (e) {
      print("ERROR: $e");
    }
  }
}