import 'package:flutter/material.dart';
import 'package:mi_app/models/producto_lite.dart';
import 'package:mi_app/services/api_service.dart';

class ProductoLiteProvider extends ChangeNotifier {
  List<ProductoLite> productosLite = [];
  bool _yacargo = false;

  Future<void> cargarProviderProductos() async {
    if (_yacargo) return;
    _yacargo = true;
    final data = await ApiService().obtenerProductosLite();
    productosLite = data.map((e) => ProductoLite.fromJson(e)).toList();
    notifyListeners();
  }
}
