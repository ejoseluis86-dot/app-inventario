import 'package:flutter/material.dart';
import 'package:mi_app/models/insumo.dart';
import 'package:mi_app/providers/insumos_provider.dart';
import 'package:mi_app/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:mi_app/providers/user_provider.dart';

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
    'Textil',
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
    final user = context.watch<UserProvider>();
    final puedeEditar = user.rol == "ADMIN";

    return Scaffold(
      appBar: AppBar(title: const Text("Detalle Insumo")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              enabled: puedeEditar,
              decoration: const InputDecoration(
                labelText: "Nombre",
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: stockController,
              enabled: puedeEditar,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Stock",
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              initialValue: categorias.contains(categoria) ? categoria : null,
              items: categorias.map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: puedeEditar
                ? (value) {
                    setState(() {
                      categoria = value;
                    });
                  }
                : null,
              decoration: const InputDecoration(labelText: "Categoría"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: ubicacionController,
              enabled: puedeEditar,
              decoration: const InputDecoration(
                labelText: "Ubicación",
              ),
            ),

            const SizedBox(height: 20),

            //BOTON GUARDAR
            if (puedeEditar)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  onPressed: _guardar,
                  label: const Text("Guardar cambios"),
                ),
              ),

            const SizedBox(height: 10),

            // BOTON ACTIVAR / DESACTIVAR
            if (user.rol == "ADMIN")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(
                    (widget.insumo.activo ?? true) ? Icons.pause : Icons.play_arrow,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (widget.insumo.activo == true) ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final confirmar = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(
                          (widget.insumo.activo ?? true)
                              ? "Desactivar insumo"
                              : "Activar insumo",
                        ),
                        content: Text(
                          (widget.insumo.activo ?? true)
                              ? "¿Querés desactivar este insumo?"
                              : "¿Querés activar este insumo?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancelar"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Confirmar"),
                          ),
                        ],
                      ),
                    );

                    if (confirmar != true) return;

                    final ok = await api.toggleInsumo(widget.insumo.id);

                    if (ok) {
                      await context.read<InsumoProvider>().cargarProviderInsumos();

                      if (mounted) Navigator.pop(context);
                    }
                  },
                  label: Text(
                    (widget.insumo.activo ?? true) ? "Desactivar" : "Activar",
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
