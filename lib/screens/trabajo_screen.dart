import 'package:flutter/material.dart';
import 'package:mi_app/models/detalle_pedido.dart';
import 'package:mi_app/models/pedido_lite.dart';

class AreaTrabajo extends StatefulWidget {
  final PedidoLite pedidoLite;

  const AreaTrabajo({super.key, required this.pedidoLite});

  @override
  State<AreaTrabajo> createState() => _AreaTrabajoState();
}

class _AreaTrabajoState extends State<AreaTrabajo> {
  late List<DetallePedido> detalles;

  @override
  void initState() {
    super.initState();

    // SIMULACION REAL
    detalles = [
      DetallePedido(
        descuento: 0,
        productoId: 5,
        cantidad: 1,
        precioUnitario: 100,
        pedidoId: widget.pedidoLite.id,
      ),
      DetallePedido(
        descuento: 0,
        productoId: 3,
        cantidad: 1,
        precioUnitario: 80,
        pedidoId: widget.pedidoLite.id,
      ),
    ];
  }

  void volver() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área de Trabajo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: volver,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: detalles.length,
        itemBuilder: (context, index) {
          final detalle = detalles[index];

          return Card(
            child: ListTile(
              title: Text("Producto ID: ${detalle.productoId}"),
              subtitle: Text(
                "Cantidad: ${detalle.cantidad}\nPrecio: \$${detalle.precioUnitario}",
              ),
              onTap: () {
                _abrirDialog(detalle);
              },
            ),
          );
        },
      ),
    );
  }

  void _abrirDialog(DetallePedido detalle) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Control de producción"),
          content: const Text("Acá va consumo real de insumos"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }
}
