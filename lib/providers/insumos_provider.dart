import 'package:flutter/material.dart';
import 'package:mi_app/models/insumo.dart';
import 'package:mi_app/services/api_service.dart';
import 'package:mi_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
class InsumoProvider extends ChangeNotifier {
  final ApiService api = ApiService();

  List<Insumo> insumos = [];

  List<Insumo> get insumosCriticos {
    // Trae todo lo que sea menor o igual a 5 (incluye urgentes de 0 a 2 y críticos de 3 a 5)
  return insumos.where((i) => i.stock <= 5).toList();
  }
  
  List<Insumo> get activos =>
    insumos.where((i) => i.activo == true).toList();

List<Insumo> get inactivos =>
    insumos.where((i) => i.activo == false).toList();

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
          activo: insumo.activo,
          
        );
      }
      return insumo;
    }).toList();

    notifyListeners();
  }
}
