import 'package:flutter/material.dart';
import 'package:mi_app/models/producto_lite.dart';
import 'package:mi_app/services/api_service.dart';

class ProductoLiteProvider extends ChangeNotifier {
  List<ProductoLite> productosLite = [];
  final ApiService api = ApiService();

  Future<void> cargarProviderProductos() async {
    final data = await api.obtenerProductosLite();
    productosLite = data.map((e) => ProductoLite.fromJson(e)).toList();
    notifyListeners();
  }
}
/*  Future<void> cargarProviderInsumos() async {
    final data = await api.obtenerInsumos();

    insumos = data.map<Insumo>((json) => Insumo.fromJson(json)).toList();

    notifyListeners();
  } */