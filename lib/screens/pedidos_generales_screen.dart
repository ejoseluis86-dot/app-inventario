import 'package:flutter/material.dart';
import 'package:mi_app/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:mi_app/screens/pedido_detalle_screen.dart';
import 'package:mi_app/screens/crear_pedido_screen.dart';

// En pedidos_generales_screen.dart
class PedidosGeneralScreen extends StatelessWidget {
  const PedidosGeneralScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "GESTIÓN DE PEDIDOS",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.pending_actions), text: "Activos"),
              Tab(icon: Icon(Icons.history), text: "Historial"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ListaPedidosGenerica(esTerminado: false),
            ListaPedidosGenerica(esTerminado: true),
          ],
        ),
        // BOTÓN FLOTANTE: Asegúrate de que esté aquí, como propiedad del Scaffold
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navegación directa
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CrearPedidoScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class ListaPedidosGenerica extends StatefulWidget {
  final bool esTerminado;
  const ListaPedidosGenerica({required this.esTerminado});
  //
  @override
  State<ListaPedidosGenerica> createState() => ListaPedidosGenericaState();
}

class ListaPedidosGenericaState extends State<ListaPedidosGenerica> {
  late Future<List<dynamic>> _futurePedidos;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() {
    setState(() {
      _futurePedidos = widget.esTerminado
          ? ApiService().obtenerPedidosTerminados()
          : ApiService().obtenerPedidosLite();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _futurePedidos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 8),
                Text(
                  "No hay registros",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                ),
              ],
            ),
          );
        }

        final pedidos = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async => _cargarDatos(),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final p = pedidos[index];
              print("DEBUG: campos disponibles en pedido: ${p.keys.toList()}");
              final fechaFormateada = p['fecha'] != null
                  ? DateFormat(
                      'dd/MM/yyyy HH:mm',
                    ).format(DateTime.parse(p['fecha']))
                  : "Sin fecha";

              // Eliminamos el SizedBox.shrink() fantasma para que la UI se dibuje real
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: widget.esTerminado
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                    child: Icon(
                      widget.esTerminado ? Icons.check_circle : Icons.schedule,
                      color: widget.esTerminado ? Colors.green : Colors.orange,
                    ),
                  ),
                  title: Text(
                    p['cliente'] ?? "Cliente Anónimo",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Orden #${p['id']} • $fechaFormateada"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    _abrirDetallePedido(
                      p['id'],
                      p['cliente'] ?? "Cliente Anónimo",
                      widget.esTerminado,
                      p['fecha']?.toString() ??
                          "Sin fecha", // <-- Aquí usamos la clave correcta
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _abrirDetallePedido(
    int idPedido,
    String cliente,
    bool esTerminado,
    String fecha,
  ) async {
    // Capturamos el resultado del pop
    final realizoCambio = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PedidoDetalleScreen(
          idPedido: idPedido,
          cliente: cliente,
          esTerminado: esTerminado,
          fecha: fecha,
        ),
      ),
    );

    // Si recibimos 'true', significa que el stock fue afectado y debemos recargar la lista
    if (realizoCambio == true && mounted) {
      _cargarDatos(); // Esto refresca el FutureBuilder llamando a la API nuevamente
    }
  }
}
