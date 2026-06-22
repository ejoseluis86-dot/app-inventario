import 'package:flutter/material.dart';
import 'package:mi_app/models/insumo.dart';
import 'package:mi_app/services/api_service.dart';

class InsumoProvider extends ChangeNotifier {
  final ApiService api = ApiService();

  List<Insumo> insumos = [];

  Future<void> cargarProviderInsumos() async {
    final data = await api.obtenerInsumos();

    insumos = data.map<Insumo>((json) => Insumo.fromJson(json)).toList();

    notifyListeners();
  }

  void actualizarStockLocal(int id, int nuevoStock) {
    insumos = insumos.map((insumo) {
      if (insumo.id == id) {
        return Insumo(
          id: insumo.id,
          nombre: insumo.nombre,
          stock: nuevoStock,
          ubicacion: insumo.ubicacion,
          categoria: insumo.categoria,
        );
      }
      return insumo;
    }).toList();

    notifyListeners();
  }
}
