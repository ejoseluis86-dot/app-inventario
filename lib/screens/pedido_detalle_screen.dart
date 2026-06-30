import 'package:flutter/material.dart';
import 'package:mi_app/services/api_service.dart';

class PedidoDetalleScreen extends StatefulWidget {
  final int idPedido;
  final String cliente;
  final bool esTerminado;
  final String? fecha;

  const PedidoDetalleScreen({
    super.key, 
    required this.idPedido, 
    required this.cliente, 
    required this.esTerminado, 
    this.fecha
  });

  @override
  State<PedidoDetalleScreen> createState() => _PedidoDetalleScreenState();
}

class _PedidoDetalleScreenState extends State<PedidoDetalleScreen> {
  List<dynamic> items = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final data = await ApiService().obtenerDetallesPedido(widget.idPedido);
      if (mounted) {
        setState(() {
          items = data;
          cargando = false;
        });
      }
    } catch (e) {
      print("Error al cargar detalles: $e");
    }
  }


Future<void> _finalizarPedido(BuildContext context) async {
  try {
    await ApiService().finalizarPedido(widget.idPedido);
    if (mounted) {
      // Enviamos 'true' para avisar que hubo cambios
      Navigator.pop(context, true); 
    }
  } catch (e) {
    print("Error: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalle: ${widget.cliente}")),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(item['producto_nombre'] ?? "Sin nombre"),
                        subtitle: Text("Cant: ${item['cantidad']}"),
                      ),
                      if (!widget.esTerminado)
                        _WidgetInsumos(idDetalle: item['id'] ?? 0, idProducto: item['producto_id'] ?? 0),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _WidgetInsumos extends StatefulWidget {
  final int idDetalle, idProducto;
  const _WidgetInsumos({required this.idDetalle, required this.idProducto});
  @override
  State<_WidgetInsumos> createState() => _WidgetInsumosState();
}

class _WidgetInsumosState extends State<_WidgetInsumos> {
  List<dynamic> receta = [];
  Map<int, double> cambiosLocales = {};

  @override
  void initState() {
    super.initState();
    _cargarReceta();
  }

  Future<void> _cargarReceta() async {
    final data = await ApiService().obtenerRecetaProducto(widget.idProducto);
    if (mounted) setState(() => receta = data);
  }

  void _ajustar(int idInsumo, double delta) {
    setState(() {
      // Obtenemos el valor actual (iniciando en 0.0)
      double valorActual = cambiosLocales[idInsumo] ?? 0.0;
      cambiosLocales[idInsumo] = (valorActual + delta).clamp(0.0, double.infinity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: receta.asMap().entries.map((entry) {
        final int index = entry.key;
        final i = entry.value;
        // Usamos el ID del insumo de la BD o el índice como fallback
        final int idInsumo = (i['id'] as num?)?.toInt() ?? index;
        final double valorMostrado = cambiosLocales[idInsumo] ?? 0.0;

        return ListTile(
          title: Text(i['insumo']?.toString() ?? "Insumo"),
          subtitle: Text("Teórico: ${i['cantidadTeorica'] ?? 0}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: valorMostrado > 0 ? () => _ajustar(idInsumo, -1.0) : null,
              ),
              Text(valorMostrado.toStringAsFixed(1), 
                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.green),
                onPressed: () => _ajustar(idInsumo, 1.0),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}