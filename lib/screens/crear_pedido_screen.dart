import 'package:flutter/material.dart';
import 'package:mi_app/models/detalle_pedido.dart';
import 'package:mi_app/models/pedido.dart';
import 'package:mi_app/models/producto_lite.dart';
import 'package:mi_app/providers/pedido_lite_provider.dart';
import 'package:mi_app/providers/producto_lite_provider.dart';
import 'package:mi_app/services/api_service.dart';
import 'package:provider/provider.dart';

class CrearPedidoScreen extends StatefulWidget {
  const CrearPedidoScreen({super.key});

  @override
  State<CrearPedidoScreen> createState() => _CrearPedidoScreenState();
}

class _CrearPedidoScreenState extends State<CrearPedidoScreen> {
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController descuentoController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();

  late List<ProductoLite> productos;
  ProductoLite? productoSeleccionado;
  final List<DetallePedido> detallesPedido = [];

  @override
  void dispose() {
    cantidadController.dispose();
    descuentoController.dispose();
    nombreController.dispose();
    super.dispose();
  }

  void agregarDetalle() {
    if (productoSeleccionado == null || cantidadController.text.isEmpty) {
      return;
    }
    setState(() {
      detallesPedido.add(
        DetallePedido(
          cantidad: int.parse(cantidadController.text),
          descuento: double.tryParse(descuentoController.text) ?? 0.0,
          precioUnitario: productoSeleccionado!.precio,
          // 🛡️ PROTECCIÓN 1: Si el id es null, le ponemos 0 por defecto para que no falle
          productoId: productoSeleccionado!.id ?? 0, 
          pedidoId: null,
        ),
      );
      cantidadController.clear();
      descuentoController.clear();
    });
  }

  void eliminarDetalle(int index) {
    setState(() {
      detallesPedido.removeAt(index);
    });
  }

  Future<void> guardarPedido() async {
    if (nombreController.text.isEmpty || detallesPedido.isEmpty) return;

    final Pedido nuevoPedido = Pedido(
      fecha: DateTime.now(),
      cliente: nombreController.text,
      usuario: 1,
      detalles: detallesPedido,
      terminado: false,
    );

    bool ok = await ApiService().crearPedido(nuevoPedido);

    if (ok) {
      await context.read<PedidoLiteProvider>().cargarProviderPedidos();
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productos = context.watch<ProductoLiteProvider>().productosLite;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear Pedido',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del cliente',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<ProductoLite>(
              value: productoSeleccionado,
              decoration: const InputDecoration(
                labelText: 'Seleccionar Producto',
                border: OutlineInputBorder(),
              ),
              items: productos.map((producto) {
                return DropdownMenuItem<ProductoLite>(
                  value: producto,
                  child: Text(producto.nombre),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  productoSeleccionado = value;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: cantidadController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descuentoController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Descuento (%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: agregarDetalle,
                icon: const Icon(Icons.add),
                label: const Text('Agregar'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: detallesPedido.isEmpty
                  ? const Center(child: Text('No hay detalles agregados'))
                  : ListView.builder(
                      itemCount: detallesPedido.length,
                      itemBuilder: (context, index) {
                        final detalle = detallesPedido[index];

                        // Buscamos el producto usando orElse por si las dudas
                        final productoAsociado = productos.firstWhere(
                          (p) => p.id == detalle.productoId,
                          orElse: () => ProductoLite(
                            id: 0,
                            nombre: "Producto Desconocido",
                            precio: 0.0,
                            categoria: "Ninguna",
                            activo: false,
                          ),
                        );

                        return Card(
                          child: ListTile(
                            title: Text(productoAsociado.nombre), // 👈 Cambiado por productoAsociado
                            subtitle: Text(
                              'Cantidad: ${detalle.cantidad} -\n precio unitario: \$${detalle.precioUnitario.toStringAsFixed(2)} -\n precio producto: \$${productoAsociado.precio.toStringAsFixed(2)} -\n descuento: ${detalle.descuento}% ',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => eliminarDetalle(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: guardarPedido,
                child: const Text('GUARDAR PEDIDO'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}