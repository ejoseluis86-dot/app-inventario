import 'package:flutter/material.dart';
import 'package:mi_app/models/pedido_lite.dart';
import 'package:mi_app/providers/pedido_lite_provider.dart';
import 'package:mi_app/screens/trabajo_screen.dart';
import 'package:provider/provider.dart';

class TrabajoPedidosScreen extends StatefulWidget {
  const TrabajoPedidosScreen({super.key});

  @override
  State<TrabajoPedidosScreen> createState() => _TrabajoPedidosScreen();
}

class _TrabajoPedidosScreen extends State<TrabajoPedidosScreen> {
  //estos pedidos vendran de una consulta a la base de datos
  //SELECT id, cliente, fecha  FROM pedido ORDER BY nombre
  //final response = await http.get(...);
  //final List<dynamic> jsonData = jsonDecode(response.body);
  //List<PedidoSimple> pedidos = jsonData.map((json) => PedidoSimple.fromJson(json)).toList();
  //TODOS los pedidos sin terminar
  final List<PedidoLite> pedidos = [
    PedidoLite(id: 1, cliente: "Gabriela", fecha: DateTime.now()),
    PedidoLite(id: 5, cliente: "Matias", fecha: DateTime.now()),
    PedidoLite(id: 8, cliente: "Sabrina", fecha: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    //estos son los pedidos del provider cargados en el login
    final pedidos = context.read<PedidoLiteProvider>().pedidosLite;
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos')),
      body: pedidos.isEmpty
          ? const Center(
              child: Text(
                'No hay pedidos pendientes',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final pedido = pedidos[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AreaTrabajo(pedidoLite: pedido),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(pedido.cliente),
                      subtitle: Text(
                        'fecha: ${pedido.fecha.day}/${pedido.fecha.month}/${pedido.fecha.year}\n',
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
