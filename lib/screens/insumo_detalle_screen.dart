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
  final _formKey = GlobalKey<FormState>();

  String? categoria;
  bool _esEditando = false; // Variable para controlar el modo de edición
  final categorias = [
    'Cerámica',
    'Plástico',
    'Metal',
    'Madera',
    'Papel',
    'Vidrio',
    'Textil',
  ];

  String? errorNombre;
  String? errorGeneral;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.insumo.nombre);
    ubicacionController = TextEditingController(text: widget.insumo.ubicacion);
    stockController = TextEditingController(text: widget.insumo.stock.toString());
    categoria = widget.insumo.categoria;
  }

  @override
  void dispose() {
    nombreController.dispose();
    ubicacionController.dispose();
    stockController.dispose();
    super.dispose();
  }

  // Widget auxiliar para mostrar las filas de información limpia en Modo Lectura
  Widget _buildDatoLectura({required IconData icon, required String label, required String valor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey, size: 28),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 2),
              Text(valor, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final esAdmin = userProvider.rol == "ADMIN";

    return Scaffold(
      appBar: AppBar(
        title: Text(_esEditando ? "Editar Insumo" : "Detalle de Insumo"),
        actions: [
          // Si es Admin, le mostramos el botón de alternar Modo Lectura / Modo Edición
          if (esAdmin)
            IconButton(
              icon: Icon(_esEditando ? Icons.cancel : Icons.edit),
              tooltip: _esEditando ? "Cancelar Edición" : "Editar Insumo",
              onPressed: () {
                setState(() {
                  if (_esEditando) {
                    // Si cancela, restauramos los valores originales de los inputs
                    nombreController.text = widget.insumo.nombre;
                    ubicacionController.text = widget.insumo.ubicacion;
                    stockController.text = widget.insumo.stock.toString();
                    categoria = widget.insumo.categoria;
                    errorNombre = null;
                    errorGeneral = null;
                  }
                  _esEditando = !_esEditando;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: _esEditando 
          ? Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (errorGeneral != null) ...[
                    Text(errorGeneral!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                  ],
                  TextFormField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      labelText: "Nombre del Insumo",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.inventory_2),
                      errorText: errorNombre,
                    ),
                    validator: (value) => value == null || value.trim().isEmpty ? "El nombre es obligatorio" : null,
                    onChanged: (_) {
                      if (errorNombre != null) setState(() => errorNombre = null);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Cantidad en Stock",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "El stock es obligatorio";
                      if (int.tryParse(value.trim()) == null) return "Debe ser un número entero válido";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: categoria,
                    decoration: const InputDecoration(
                      labelText: "Categoría",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) => setState(() => categoria = val),
                    validator: (value) => value == null ? "La categoría es obligatoria" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: ubicacionController,
                    decoration: const InputDecoration(
                      labelText: "Ubicación / Depósito",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.place),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty ? "La ubicación es obligatoria" : null,
                  ),
                  const SizedBox(height: 24),
                  
                  // Botón Guardar Cambios
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                    icon: const Icon(Icons.save),
                    label: const Text("GUARDAR CAMBIOS", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      setState(() {
                        errorNombre = null;
                        errorGeneral = null;
                      });

                      if (!_formKey.currentState!.validate()) return;

                      final nuevoStock = int.parse(stockController.text.trim());

                      final resError = await api.actualizarInsumo(
                        id: widget.insumo.id,
                        nombre: nombreController.text.trim(),
                        categoria: categoria!,
                        stock: nuevoStock,
                        ubicacion: ubicacionController.text.trim(),
                      );

                      if (resError != null) {
                        setState(() {
                          if (resError.toLowerCase().contains("nombre")) {
                            errorNombre = resError;
                          } else {
                            errorGeneral = resError;
                          }
                        });
                        return;
                      }

                      await context.read<InsumoProvider>().cargarProviderInsumos();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Insumo actualizado con éxito"), backgroundColor: Colors.green),
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  // Botón Activar / Desactivar
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: (widget.insumo.activo ?? true) ? Colors.red : Colors.green),
                    ),
                    icon: Icon(
                      (widget.insumo.activo ?? true) ? Icons.visibility_off : Icons.visibility,
                      color: (widget.insumo.activo ?? true) ? Colors.red : Colors.green,
                    ),
                    label: Text(
                      (widget.insumo.activo ?? true) ? "DESACTIVAR INSUMO" : "ACTIVAR INSUMO",
                      style: TextStyle(
                        color: (widget.insumo.activo ?? true) ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      final bool? confirmar = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text((widget.insumo.activo ?? true) ? "Desactivar insumo" : "Activar insumo"),
                          content: Text((widget.insumo.activo ?? true)
                              ? "¿Querés desactivar este insumo?"
                              : "¿Querés activar este insumo?"),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
                            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Confirmar")),
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
                  ),
                ],
              ),
            )
          : Column(
              
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildDatoLectura(icon: Icons.inventory_2, label: "Nombre", valor: widget.insumo.nombre),
                        const Divider(),
                        _buildDatoLectura(icon: Icons.numbers, label: "Stock Disponible", valor: "${widget.insumo.stock} unidades"),
                        const Divider(),
                        _buildDatoLectura(icon: Icons.category, label: "Categoría", valor: widget.insumo.categoria),
                        const Divider(),
                        _buildDatoLectura(icon: Icons.place, label: "Ubicación en depósito", valor: widget.insumo.ubicacion),
                        const Divider(),
                        _buildDatoLectura(
                          icon: Icons.info_outline, 
                          label: "Estado operativo", 
                          valor: (widget.insumo.activo ?? true) ? "Activo (Visible en producción)" : "Inactivo (Archivado)",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}