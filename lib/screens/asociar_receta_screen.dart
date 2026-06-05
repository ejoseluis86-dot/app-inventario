import 'package:flutter/material.dart';
import 'package:mi_app/models/detalle_receta.dart';
import 'package:mi_app/models/insumo.dart';
import 'package:mi_app/models/producto.dart';

class AsociarRecetaScreen extends StatefulWidget {
  final String nombreProducto;
  final double precioProducto;
  final String categoria;
  const AsociarRecetaScreen({
    super.key,
    required this.nombreProducto,
    required this.precioProducto,
    required this.categoria,
  });

  @override
  State<AsociarRecetaScreen> createState() => _AsociarRecetaScreenState();
}

class _AsociarRecetaScreenState extends State<AsociarRecetaScreen> {
  late final TextEditingController cantidadController = TextEditingController();

  final List<Insumo> insumosBD = [
    Insumo(id: 1, nombre: 'Harina', categoria: '', stock: 5, ubicacion: ''),
    Insumo(id: 2, nombre: 'Azúcar', categoria: '', stock: 10, ubicacion: ''),
    Insumo(id: 3, nombre: 'Huevos', categoria: '', stock: 15, ubicacion: ''),
    Insumo(id: 4, nombre: 'Chocolate', categoria: '', stock: 3, ubicacion: ''),
    Insumo(id: 5, nombre: 'Leche', categoria: '', stock: 6, ubicacion: ''),
  ];

  final List<String> insumos = [];

  @override
  void initState() {
    super.initState();
    for (var insumo in insumosBD) {
      insumos.add(insumo.nombre);
    }
  }

  Insumo? insumoSeleccionado;

  //esta es un alista de detalles que se usa para mostrar y crear la receta
  final List<DetalleReceta> detalles = [];

  @override
  void dispose() {
    //esto es para destruir los controladores de texto cuando ya no se necesiten, para liberar recursos
    cantidadController.dispose();
    super.dispose();
  }

  void agregarDetalle() {
    if (insumoSeleccionado == null || cantidadController.text.isEmpty) {
      return;
    }
    setState(() {
      detalles.add(
        //aca estoy creando un nuevo detalle de receta con el insumo seleccionado y la cantidad ingresada, y lo agrego a la lista de detalles
        DetalleReceta(
          cantidadTeorica: int.parse(cantidadController.text),
          insumoId: insumoSeleccionado!.id!,
        ),
      );
      cantidadController.clear();
      insumoSeleccionado = null;
    });
  }

  void eliminarDetalle(int index) {
    setState(() {
      detalles.removeAt(index);
    });
  }

  //esto no iria hay que modificar
  void guardarReceta() {
    final Producto nuevoProducto = Producto(
      nombre: widget.nombreProducto,
      precio: widget.precioProducto,
      categoria: widget.categoria,
      detalles: detalles,
    );
    print('Producto a guardar: ${nuevoProducto.toJson()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Asociar Receta',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.nombreProducto,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              initialValue: insumoSeleccionado?.nombre,
              decoration: const InputDecoration(
                labelText: 'SeleccionarInsumo Base',
                border: OutlineInputBorder(),
              ),
              items: insumos.map((insumo) {
                return DropdownMenuItem(value: insumo, child: Text(insumo));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  insumoSeleccionado = insumosBD.firstWhere(
                    (insumo) => insumo.nombre == value,
                  );
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
                labelText: 'Cantidad Teorica Requerida',
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
              child: detalles.isEmpty
                  ? const Center(child: Text('No hay detalles agregados'))
                  : ListView.builder(
                      itemCount: detalles.length,
                      itemBuilder: (context, index) {
                        final detalle = detalles[index];

                        return Card(
                          child: ListTile(
                            title: Text(
                              insumosBD
                                  .firstWhere(
                                    (insumo) => insumo.id == detalle.insumoId,
                                  )
                                  .nombre,
                            ),
                            subtitle: Text(
                              'Cantidad: ${detalle.cantidadTeorica}',
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
                onPressed: guardarReceta,
                child: const Text('GUARDAR RECETA COMPLETA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
