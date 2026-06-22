import 'package:flutter/material.dart';
import 'package:mi_app/models/insumo.dart';
import 'package:mi_app/providers/insumos_provider.dart';
import 'package:mi_app/services/api_service.dart';
import 'package:provider/provider.dart';

class InsumoDetalleScreen extends StatefulWidget {
  final Insumo insumo;

  const InsumoDetalleScreen({super.key, required this.insumo});

  @override
  State<InsumoDetalleScreen> createState() => _InsumoDetalleScreenState();
}

class _InsumoDetalleScreenState extends State<InsumoDetalleScreen> {
  late TextEditingController nombreController;
  late TextEditingController ubicacionController;
  late TextEditingController stockController;

  final ApiService api = ApiService();

  String? categoria;

  final categorias = [
    'Cerámica',
    'Plástico',
    'Metal',
    'Madera',
    'Papel',
    'Vidrio',
  ];

  @override
  void initState() {
    super.initState();

    nombreController = TextEditingController(text: widget.insumo.nombre);

    ubicacionController = TextEditingController(text: widget.insumo.ubicacion);

    stockController = TextEditingController(
      text: widget.insumo.stock.toString(),
    );

    categoria = widget.insumo.categoria;
  }

  Future<void> _guardar() async {
    final id = widget.insumo.id;

    final ok = await api.actualizarInsumo(
      id: id,
      nombre: nombreController.text,
      categoria: categoria ?? widget.insumo.categoria,
      stock: int.tryParse(stockController.text) ?? widget.insumo.stock,
      ubicacion: ubicacionController.text,
    );

    if (!mounted) return;

    if (ok) {
      await context.read<InsumoProvider>().cargarProviderInsumos();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al actualizar insumo"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle Insumo")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Stock"),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              initialValue: categorias.contains(categoria) ? categoria : null,
              items: categorias.map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  categoria = value;
                });
              },
              decoration: const InputDecoration(labelText: "Categoría"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: ubicacionController,
              decoration: const InputDecoration(labelText: "Ubicación"),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                onPressed: _guardar,
                label: const Text("Guardar cambios"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
