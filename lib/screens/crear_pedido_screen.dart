import 'package:flutter/material.dart';
import 'package:mi_app/models/detalle_pedido.dart';
import 'package:mi_app/models/pedido.dart';
import 'package:mi_app/models/producto_lite.dart';

class CrearPedidoScreen extends StatefulWidget {
  const CrearPedidoScreen({super.key});

  @override
  State<CrearPedidoScreen> createState() => _CrearPedidoScreenState();
}

class _CrearPedidoScreenState extends State<CrearPedidoScreen> {
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController descuentoController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final List<ProductoLite> productos = [
    ProductoLite(id: 1, nombre: "Producto 1", precio: 10.0),
    ProductoLite(id: 2, nombre: "Producto 2", precio: 20.0),
    ProductoLite(id: 3, nombre: "Producto 3", precio: 30.0),
  ];

  List<String> nombresProductos = [];
  @override
  void initState() {
    super.initState();
    for (var producto in productos) {
      nombresProductos.add(producto.nombre);
    }
  }

  ProductoLite? productoSeleccionado;

  //esta es un alista de detalles que se usa para mostrar y crear la receta
  final List<DetallePedido> detallesPedido = [];

  @override
  void dispose() {
    //esto es para destruir los controladores de texto cuando ya no se necesiten, para liberar recursos
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
        //aca estoy creando un nuevo detalle de receta con el insumo seleccionado y la cantidad ingresada, y lo agrego a la lista de detalles
        DetallePedido(
          cantidad: int.parse(cantidadController.text),
          descuento: double.tryParse(descuentoController.text) ?? 0.0,
          precioUnitario: //aca se pone el precio total con el descuento incluido
              productoSeleccionado!.precio *
                  int.parse(cantidadController.text) -
              productoSeleccionado!.precio *
                  (double.tryParse(descuentoController.text) ?? 0.0) /
                  100,
          productoId: productoSeleccionado!.id,
          pedidoId: null,
        ),
      );
      //aca limpio los campos
      cantidadController.clear();
      descuentoController.clear();
      productoSeleccionado = null;
    });
  }

  void eliminarDetalle(int index) {
    setState(() {
      detallesPedido.removeAt(index);
    });
  }

  //crea el pedido con todos los detalles incluidos
  void guardarPedido() {
    final Pedido nuevoPedido = Pedido(
      fecha: DateTime.now(),
      cliente: nombreController.text,
      usuarioId: 1, //acase irá un id de usuario de la BD
      detalles: detallesPedido,
    );
    print('Pedido a guardar: ${nuevoPedido.toJson()}');
  }

  @override
  Widget build(BuildContext context) {
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
              decoration: InputDecoration(
                labelText: 'Nombre del cliente',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              initialValue: productoSeleccionado?.nombre,
              decoration: const InputDecoration(
                labelText: 'Seleccionar Producto',
                border: OutlineInputBorder(),
              ),
              items: nombresProductos.map((nombre) {
                return DropdownMenuItem(value: nombre, child: Text(nombre));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  productoSeleccionado =
                      productos.firstWhere(
                            (producto) => producto.nombre == value,
                          )
                          as ProductoLite?;
                });
              },
            ),

            const SizedBox(height: 12),

            TextField(
              controller: cantidadController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: descuentoController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
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

                        return Card(
                          child: ListTile(
                            title: Text(
                              nombresProductos.firstWhere(
                                (nombre) =>
                                    nombre ==
                                    productos
                                        .firstWhere(
                                          (producto) =>
                                              producto.id == detalle.productoId,
                                        )
                                        .nombre,
                                orElse: () => 'Producto no encontrado',
                              ),
                            ),
                            subtitle: Text(
                              'Cantidad: ${detalle.cantidad} -\n precio unitario: \$${detalle.precioUnitario.toStringAsFixed(2)} -\n precio producto: \$${productos.firstWhere((producto) => producto.id == detalle.productoId).precio.toStringAsFixed(2)} -\n descuento: ${detalle.descuento}% ',
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
