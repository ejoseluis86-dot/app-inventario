import 'package:flutter/material.dart';
import 'package:mi_app/models/insumo.dart';
import 'package:mi_app/services/api_service.dart';

class InsumoProvider extends ChangeNotifier {
  List<Insumo> insumos = [];
  bool _yacargo = false;

  Future<void> cargarProviderInsumos() async {
    if (_yacargo) return;
    _yacargo = true;
    final data = await ApiService().obtenerInsumos();
    insumos = data.map((e) => Insumo.fromJson(e)).toList();
    print("esta es la lista desde la api en provider: $insumos");
    notifyListeners();
  }

  void agregarInsumo(Insumo insumo) {
    insumos.add(insumo);
    notifyListeners();
  }

  void actualizarStockLocal(int id, int nuevoStock) {
    final insumo = insumos.firstWhere((i) => i.id == id);
    if (id != -1) {
      insumo.stock = nuevoStock;
      notifyListeners();
    }
  }
}
