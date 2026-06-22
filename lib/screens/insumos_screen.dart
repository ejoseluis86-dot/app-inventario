import 'package:flutter/material.dart';
import 'package:mi_app/models/insumo.dart';
import 'package:mi_app/providers/insumos_provider.dart';
import 'package:mi_app/services/api_service.dart';
import 'package:provider/provider.dart';

class InsumosScreen extends StatefulWidget {
  const InsumosScreen({super.key});

  @override
  State<InsumosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<InsumosScreen> {
  final stockController = TextEditingController();

  //esta funcion es un dialog para crear insumo
  void _mostrarDialogoAgregarInsumo() {
    final nombreController = TextEditingController();
    final ubicacionController = TextEditingController();
    stockController.clear();
    final apiService = ApiService();

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

                        apiService.crearInsumo(
                          nombre: nombreController.text,
                          categoria: categoriaSeleccionada!,
                          stock: int.tryParse(stockController.text)!,
                          ubicacion: ubicacionController.text,
                        );
                        context.read<InsumoProvider>().agregarInsumo(insumo);
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
              title: Text('Agregar mas Stock a  ${miInsumo.nombre}'),
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
                      onPressed: () async {
                        if (stockController.text.isNotEmpty) {
                          miInsumo.stock = int.tryParse(stockController.text);
                          //aca se esta modificando el  insumo en base de datos
                          final api = ApiService();
                          bool ok = await api.modificarStock(
                            miInsumo.id!,
                            miInsumo.stock!,
                          );
                          //aca solo actualiza el provider la lista de insumos
                          if (ok) {
                            context.read<InsumoProvider>().actualizarStockLocal(
                              miInsumo.id!,
                              miInsumo.stock!,
                            );
                          }
                        }
                        Navigator.pop(context);
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
    final insumosBD = context.watch<InsumoProvider>().insumos;
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
                //este insumo es un json
                final insumo = Insumo.fromJson(insumosBD[index]);
                print(
                  'este es el insumo de base de datos para mostrar $insumo',
                );

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
                            'Ubicacion: ${insumo.ubicacion}',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _mostrarDialogmodificarStock(insumo);
                          });
                        },
                        child: Text("Agregar"),
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
