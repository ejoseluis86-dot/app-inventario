import 'package:flutter/material.dart';
import 'package:mi_app/models/insumo.dart';
import 'package:mi_app/services/api_service.dart';

class InsumoProvider extends ChangeNotifier {
  List<dynamic> insumos = [];
  bool _yacargo = false;

  Future<void> cargarProviderInsumos() async {
    if (_yacargo) return;
    _yacargo = true;
    insumos = await ApiService().obtenerInsumos();
    print("esta es la lista desde la api en provider: $insumos");
    notifyListeners();
  }

  void agregarInsumo(Insumo insumo) {
    insumos.add(insumo);
    notifyListeners();
  }

  void actualizarStockLocal(int id, int nuevoStock) {
    final insumo = insumos.firstWhere((i) => i['id'] == id);
    if (id != -1) {
      insumo['stock'] = nuevoStock;
      notifyListeners();
    }
  }
}
