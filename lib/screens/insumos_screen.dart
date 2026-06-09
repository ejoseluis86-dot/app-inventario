import 'package:flutter/material.dart';
import 'package:mi_app/models/insumo.dart';

class InsumosScreen extends StatefulWidget {
  const InsumosScreen({super.key});

  @override
  State<InsumosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<InsumosScreen> {
  //esta lista de insums vendra de base de datos para ser cargada y mostrada
  final List<Insumo> insumosBD = [
    Insumo(
      id: 6,
      nombre: "taza",
      categoria: "ceramica",
      stock: 5,
      ubicacion: "estante A",
    ),
  ];

  final stockController = TextEditingController();

  //esta funcion es un dialog para crear insumo
  void _mostrarDialogoAgregarInsumo() {
    final nombreController = TextEditingController();
    final ubicacionController = TextEditingController();
    stockController.clear();

    //esto es para el scroll de categorias por el moemeto sera statica y creo que para siempre XD
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
                        //este insumo es el creado y debe guardarse en base de datos

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

  //esta funcion es un dialog que recibe el Insumo a modificar y en el onpress se lo envia a la base de datos
  void _mostrarDialogmodificarStock(Insumo miInsumo) {
    stockController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Stock de  ${miInsumo.nombre}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    TextField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'cargar stock'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        miInsumo.stock = int.tryParse(stockController.text);
                        setState(() {});
                        Navigator.pop(context);
                        print(
                          "el insumo a modificar se llama" +
                              miInsumo.nombre +
                              " y tiene como id : " +
                              miInsumo.id.toString(),
                        );
                        //este insumo miInsumo debe ser modificado en la mase de datos ya sea por miInsumo.id o miInsumo.nombre y miInsumo.categoria
                      },
                      child: Text("modificar"),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
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
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(insumo.nombre),
                          subtitle: Text(
                            'Categoria: ${insumo.categoria}\n'
                            'Stock: ${insumo.stock}\n'
                            'Ubicacion:${insumo.ubicacion}',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _mostrarDialogmodificarStock(insumo);
                          });
                        },
                        child: Text("modificar"),
                      ),
                    ],
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
