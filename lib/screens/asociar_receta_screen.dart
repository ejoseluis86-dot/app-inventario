import 'package:flutter/material.dart';
import 'package:mi_app/models/detalle_receta.dart';
import 'package:mi_app/models/insumo.dart';
import 'package:mi_app/models/producto.dart';
import 'package:mi_app/providers/insumos_provider.dart';
import 'package:mi_app/providers/producto_lite_provider.dart';
import 'package:mi_app/routes/app_rutas.dart';
import 'package:mi_app/services/api_service.dart';
import 'package:provider/provider.dart';

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
    final cantidad = int.tryParse(cantidadController.text);

    if (insumoSeleccionado == null || cantidad == null) return;

    setState(() {
      detalles.add(
        DetalleReceta(
          cantidadTeorica: cantidad,
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
  Future<void> guardarReceta() async {
  final apiService = ApiService();

  if (widget.nombreProducto.trim().isEmpty ||
      widget.categoria.trim().isEmpty ||
      widget.precioProducto <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Debe completar nombre, precio y categoría'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  if (detalles.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Debe agregar al menos un insumo'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  final nuevoProducto = Producto(
    nombre: widget.nombreProducto,
    precio: widget.precioProducto,
    categoria: widget.categoria,
    detalles: detalles,
  );

  final ok = await apiService.crearProducto(nuevoProducto);

  if (ok) {
    await context.read<ProductoLiteProvider>().cargarProviderProductos();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Producto creado correctamente"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRutas.home,
      (route) => false,
    );
  } else {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("No se pudo crear el producto"),
        backgroundColor: Colors.red,
      ),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    //aca estoy trayendo una lista de insumos desde el provider
    final insumosBD = context.watch<InsumoProvider>().insumos;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // HEADER
            Text(
              widget.nombreProducto,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Arma la receta del producto",
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 20),

            // FORM CARD
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    DropdownButtonFormField<Insumo>(
                      value: insumoSeleccionado,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Insumo',
                        prefixIcon: Icon(Icons.inventory_2),
                        border: OutlineInputBorder(),
                      ),
                      items: insumosBD.map((insumo) {
                        return DropdownMenuItem(
                          value: insumo,
                          child: Text(insumo.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          insumoSeleccionado = value;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: cantidadController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad teórica',
                        prefixIcon: Icon(Icons.numbers),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: agregarDetalle,
                        icon: const Icon(Icons.add),
                        label: const Text("Agregar a receta"),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // LISTA HEADER
            const Text(
              "Insumos agregados",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // LISTA
            Expanded(
              child: detalles.isEmpty
                  ? const Center(
                      child: Text("No hay insumos agregados"),
                    )
                  : ListView.builder(
                      itemCount: detalles.length,
                      itemBuilder: (context, index) {
                        final detalle = detalles[index];

                        final insumo = insumosBD.firstWhere(
                          (i) => i.id == detalle.insumoId,
                        );

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.check_circle, color: Colors.green),

                            title: Text(insumo.nombre),

                            subtitle: Text("Cantidad: ${detalle.cantidadTeorica}"),

                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => eliminarDetalle(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 10),

            // FINAL BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: guardarReceta,
                child: const Text("Guardar producto"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}