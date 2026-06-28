import 'package:flutter/material.dart';
import 'package:mi_app/models/producto.dart';
import 'package:mi_app/models/detalle_receta.dart';
import 'package:mi_app/providers/insumos_provider.dart';
import 'package:mi_app/services/api_service.dart';
import 'package:provider/provider.dart';

class EditarProductoScreen extends StatefulWidget {
  final Producto producto;

  const EditarProductoScreen({
    super.key,
    required this.producto,
  });

  @override
  State<EditarProductoScreen> createState() =>
      _EditarProductoScreenState();
}

class _EditarProductoScreenState extends State<EditarProductoScreen> {
  final nombreController = TextEditingController();
  final precioController = TextEditingController();
  String? categoriaSeleccionada;

  List<DetalleReceta> detalles = [];

  @override
  void initState() {
    super.initState();

    nombreController.text = widget.producto.nombre;
    precioController.text = widget.producto.precio.toString();
    categoriaSeleccionada = widget.producto.categoria;
    detalles = List.from(widget.producto.detalles ?? []);
  }

  @override
  void dispose() {
    nombreController.dispose();
    precioController.dispose();
    super.dispose();
  }

  Future<void> guardarProducto() async {
  final api = ApiService();

  if (nombreController.text.trim().isEmpty ||
      precioController.text.isEmpty ||
      categoriaSeleccionada == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Completa todos los campos"),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  final ok = await api.actualizarProducto(
    id: widget.producto.id!,
    nombre: nombreController.text.trim(),
    precio: double.parse(precioController.text),
    categoria: categoriaSeleccionada!,
    detalles: detalles,
  );

  if (!mounted) return;

  if (ok) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Producto actualizado")),
    );

    Navigator.pop(context, true);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Error al actualizar"),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
@override
Widget build(BuildContext context) {
  final insumos = context.watch<InsumoProvider>().insumos;

  return Scaffold(
    appBar: AppBar(title: const Text("Editar Producto Completo")),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          // ======================
          // PRODUCTO
          // ======================
          TextField(
            controller: nombreController,
            decoration: const InputDecoration(labelText: "Nombre"),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: precioController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Precio"),
          ),

          const SizedBox(height: 10),

          DropdownButtonFormField<String>(
            value: categoriaSeleccionada,
            items: const [
              DropdownMenuItem(value: "Cerámica", child: Text("Cerámica")),
              DropdownMenuItem(value: "Plástico", child: Text("Plástico")),
              DropdownMenuItem(value: "Metal", child: Text("Metal")),
              DropdownMenuItem(value: "Madera", child: Text("Madera")),
              DropdownMenuItem(value: "Papel", child: Text("Papel")),
              DropdownMenuItem(value: "Vidrio", child: Text("Vidrio")),
              DropdownMenuItem(value: "Textil", child: Text("Textil")),
            ],
            onChanged: (value) {
              setState(() => categoriaSeleccionada = value);
            },
          ),

          const SizedBox(height: 20),

          const Divider(),

          const Text(
            "Receta",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          // ======================
          // RECETA
          // ======================
          Expanded(
            child: ListView.builder(
              itemCount: detalles.length,
              itemBuilder: (context, index) {
                final d = detalles[index];

                final insumo = insumos.firstWhere(
                  (i) => i.id == d.insumoId,
                );

                return Card(
                  child: ListTile(
                    title: Text(insumo.nombre),

                    subtitle: TextField(
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: d.cantidadTeorica.toString(),
                      ),
                      onSubmitted: (value) {
                        final cantidad = int.tryParse(value);
                        if (cantidad != null) {
                          setState(() {
                            detalles[index] = DetalleReceta(
                              id: d.id,
                              insumoId: d.insumoId,
                              cantidadTeorica: cantidad,
                            );
                          });
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // ======================
          // BOTÓN GUARDAR
          // ======================
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: guardarProducto,
              child: const Text("Guardar cambios"),
            ),
          ),
        ],
      ),
    ),
  );
}

}
