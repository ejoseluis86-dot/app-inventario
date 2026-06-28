import 'package:flutter/material.dart';
import 'package:mi_app/models/producto.dart';
import 'package:mi_app/services/api_service.dart';

class EditarProductoScreen extends StatefulWidget {
  final Producto producto;

  const EditarProductoScreen({
    super.key,
    required this.producto,
  });

  @override
  State<EditarProductoScreen> createState() => _EditarProductoScreenState();
}

class _EditarProductoScreenState extends State<EditarProductoScreen> {
  late TextEditingController nombreController;
  late TextEditingController precioController;

  String? categoriaSeleccionada;

  final categorias = [
    'Cerámica',
    'Plástico',
    'Metal',
    'Madera',
    'Papel',
    'Vidrio',
    'Textil',
  ];

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.producto.nombre);
    precioController = TextEditingController(
      text: widget.producto.precio.toString(),
    );
    categoriaSeleccionada = widget.producto.categoria;
  }

  Future<void> guardarCambios() async {
    final api = ApiService();

    final precio = double.tryParse(precioController.text);

    if (nombreController.text.trim().isEmpty ||
        precio == null ||
        precio <= 0 ||
        categoriaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete todos los campos")),
      );
      return;
    }

    final productoEditado = Producto(
      id: widget.producto.id,
      nombre: nombreController.text.trim(),
      precio: precio,
      categoria: categoriaSeleccionada!,
      detalles: widget.producto.detalles,
    );

    final ok = await api.actualizarProducto(productoEditado);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Producto actualizado"),
          backgroundColor: Colors.green,
        ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Producto")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),

            TextField(
              controller: precioController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Precio"),
            ),

            DropdownButtonFormField<String>(
              value: categoriaSeleccionada,
              items: categorias
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  categoriaSeleccionada = value;
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: guardarCambios,
              child: const Text("Guardar cambios"),
            ),
          ],
        ),
      ),
    );
  }
}