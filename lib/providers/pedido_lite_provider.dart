import 'package:flutter/material.dart';
import 'package:mi_app/models/pedido_lite.dart';
import 'package:mi_app/services/api_service.dart';

class PedidoLiteProvider extends ChangeNotifier {
  List<PedidoLite> pedidosLite = [];
  final ApiService api = ApiService();

  Future<void> cargarProviderPedidos() async {
    final data = await api.obtenerPedidosLite();
    pedidosLite = data.map((e) => PedidoLite.fromJson(e)).toList();
    notifyListeners();
  }
}
