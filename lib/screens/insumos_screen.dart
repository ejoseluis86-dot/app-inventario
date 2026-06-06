import 'package:flutter/material.dart';
import 'package:mi_app/models/insumo.dart';

class InsumosScreen extends StatefulWidget {
  const InsumosScreen({super.key});

  @override
  State<InsumosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<InsumosScreen> {
  final List<Insumo> insumosBD = [
    Insumo(
      nombre: "taza",
      categoria: "ceramica",
      stock: 5,
      ubicacion: "estante A",
    ),
  ];

  void _mostrarDialogoAgregarInsumo() {
    final nombreController = TextEditingController();
    final stockController = TextEditingController();
    final ubicacionController = TextEditingController();

    //esto es para el scroll de categorias por el moemeto sera statica
    final List<String> categorias = ['ceramica', 'plactico', 'metal', 'madera'];
    String? categoriaSeleccionada;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Nuevo Insumo'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nombreController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Stock'),
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      initialValue: categoriaSeleccionada,
                      decoration: const InputDecoration(
                        labelText: '',
                        border: OutlineInputBorder(),
                      ),
                      items: categorias.map((categoria) {
                        return DropdownMenuItem(
                          value: categoria,
                          child: Text(categoria),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          categoriaSeleccionada = value;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: ubicacionController,
                      decoration: const InputDecoration(labelText: 'Ubicacion'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nombreController.text.isNotEmpty &&
                        stockController.text.isNotEmpty &&
                        ubicacionController.text.isNotEmpty &&
                        categoriaSeleccionada != null) {
                      setState(() {
                        //este insumo debe guardarse en base de datos
                        Insumo insumo = Insumo(
                          nombre: nombreController.text,
                          categoria: categoriaSeleccionada!,
                          stock: int.tryParse(stockController.text)!,
                          ubicacion: ubicacionController.text,
                        );
                        insumosBD.add(insumo);
                        print(insumo.toString());
                      });

                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('INSUMOS')),
      body: insumosBD.isEmpty
          ? const Center(
              child: Text(
                'No hay productos registrados',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: insumosBD.length,
              itemBuilder: (context, index) {
                final insumo = insumosBD[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(insumo.nombre),
                    subtitle: Text(
                      'Categoria: \$${insumo.categoria}\n'
                      'Stock: \$${insumo.stock}\n'
                      'Ubicacion: ${insumo.ubicacion}',
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoAgregarInsumo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
