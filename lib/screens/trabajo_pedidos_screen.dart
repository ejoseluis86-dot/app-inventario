import 'package:flutter/material.dart';
import 'package:mi_app/models/detalle_pedido.dart';
import 'package:mi_app/models/pedido_lite.dart';
import 'package:mi_app/models/producto_lite.dart';
import 'package:mi_app/providers/pedido_lite_provider.dart';
import 'package:provider/provider.dart';
import 'package:mi_app/providers/producto_lite_provider.dart';
import 'package:mi_app/screens/trabajo_screen.dart';



class TrabajoPedidosScreen extends StatelessWidget {
  const TrabajoPedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pedidos = context.watch<PedidoLiteProvider>().pedidosLite;

    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos activos')),
      body: pedidos.isEmpty
          ? const Center(child: Text('No hay pedidos'))
          : ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final p = pedidos[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(p.cliente),
                    subtitle: Text(
                      "${p.fecha.day}/${p.fecha.month}/${p.fecha.year}",
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AreaTrabajo(pedidoLite: p),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}