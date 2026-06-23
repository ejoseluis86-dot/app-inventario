import 'package:flutter/material.dart';
import 'package:mi_app/providers/insumos_provider.dart';
import 'package:mi_app/providers/user_provider.dart';
import 'package:mi_app/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:mi_app/screens/insumo_detalle_screen.dart';

class InsumosScreen extends StatefulWidget {
  final bool soloCriticos;

  const InsumosScreen({
    super.key,
    this.soloCriticos = false,
  });

  @override
  State<InsumosScreen> createState() => _InsumosScreenState();
}

class _InsumosScreenState extends State<InsumosScreen> {
  final nombreController = TextEditingController();
  final stockController = TextEditingController();
  final ubicacionController = TextEditingController();

  final ApiService api = ApiService();

  String search = "";
  String? filtroCategoria;
  String? filtroStock;

//muestra filtro de crticos desde pantalla principal  @override
void initState() {
  super.initState();

  if (widget.soloCriticos) {
    filtroStock = "CRITICO";
  }
}

  void _mostrarDialogo() {
    final categorias = [
      'Cerámica',
      'Plástico',
      'Metal',
      'Madera',
      'Papel',
      'Vidrio',
    ];

    String? categoria;
    bool loading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              title: const Text("Nuevo Insumo"),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: "Nombre",
                      prefixIcon: Icon(Icons.inventory_2),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Stock",
                      prefixIcon: Icon(Icons.numbers),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: categoria,
                    decoration: const InputDecoration(
                      labelText: "Categoría",
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(),
                    ),
                    items: categorias
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        categoria = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: ubicacionController,
                    decoration: const InputDecoration(
                      labelText: "Ubicación",
                      prefixIcon: Icon(Icons.place),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  if (loading)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),

                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Guardar"),

                  onPressed: loading
                      ? null
                      : () async {
                          if (nombreController.text.isEmpty ||
                              stockController.text.isEmpty ||
                              ubicacionController.text.isEmpty ||
                              categoria == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Completá todos los campos"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          setStateDialog(() => loading = true);

                          final ok = await api.crearInsumo(
                            nombre: nombreController.text,
                            categoria: categoria!,
                            stock: int.parse(stockController.text),
                            ubicacion: ubicacionController.text,
                          );

                          setStateDialog(() => loading = false);

                          if (ok) {
                            await context
                                .read<InsumoProvider>()
                                .cargarProviderInsumos();

                            Navigator.pop(context);

                            nombreController.clear();
                            stockController.clear();
                            ubicacionController.clear();
                          }
                        },
                ),
              ],
            );
          },
        );
      },
    );
  }

  //Semáforo de stock
    Color colorStock(int stock) {
    if (stock <= 2) return Colors.red;
    if (stock <= 5) return Colors.orange;
    return Colors.green;
  }

    String estadoStock(int stock) {
      if (stock <= 2) return "Urgente";
      if (stock <= 5) return "Crítico";
      return "OK";
    }

  @override
  Widget build(BuildContext context) {
    final insumos = context.watch<InsumoProvider>().insumos;
    final rol = context.watch<UserProvider>().rol;

    // FILTRO APLICADO
    final filtrados = insumos.where((i) {
    final nombre = i.nombre.toLowerCase();

    final matchSearch = nombre.contains(search);

    final matchCategoria =
        filtroCategoria == null ||
        i.categoria == filtroCategoria;

    final matchCritico =
        !widget.soloCriticos ||
        i.stock <= 5;

    final matchStock =
      filtroStock == null ||
      (filtroStock == "OK" && i.stock > 5) ||
      (filtroStock == "CRITICO" &&
          i.stock > 2 &&
          i.stock <= 5) ||
      (filtroStock == "URGENTE" &&
          i.stock <= 2);    

    return matchSearch &&
      matchCategoria &&
      matchCritico &&
      matchStock;
    }).toList()
    ..sort(
      (a, b) => a.nombre
          .toLowerCase()
          .compareTo(b.nombre.toLowerCase()),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("INSUMOS")),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Buscar insumo",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  search = value.toLowerCase();
                });
              },
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: filtroCategoria,
              decoration: const InputDecoration(
                labelText: "Filtrar por categoría",
                prefixIcon: Icon(Icons.filter_list),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: null, child: Text("Todas")),
                DropdownMenuItem(value: "Cerámica", child: Text("Cerámica")),
                DropdownMenuItem(value: "Plástico", child: Text("Plástico")),
                DropdownMenuItem(value: "Metal", child: Text("Metal")),
                DropdownMenuItem(value: "Madera", child: Text("Madera")),
                DropdownMenuItem(value: "Papel", child: Text("Papel")),
                DropdownMenuItem(value: "Vidrio", child: Text("Vidrio")),
              ],
              onChanged: (value) {
                setState(() {
                  filtroCategoria = value;
                });
              },
            ),

          const SizedBox(height: 10),

          DropdownButtonFormField<String>(
            value: filtroStock,
            decoration: const InputDecoration(
              labelText: "Estado de stock",
              prefixIcon: Icon(Icons.traffic),
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: null,
                child: Text("Todos"),
              ),
              DropdownMenuItem(
                value: "OK",
                child: Text("🟢 OK"),
              ),
              DropdownMenuItem(
                value: "CRITICO",
                child: Text("🟠 Crítico"),
              ),
              DropdownMenuItem(
                value: "URGENTE",
                child: Text("🔴 Urgente"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                filtroStock = value;
              });
            },
          ),  

            const SizedBox(height: 10),

            Expanded(
              child: filtrados.isEmpty
                  ? const Center(child: Text("No hay insumos"))
                  : ListView.builder(
                      itemCount: filtrados.length,
                      itemBuilder: (context, index) {
                        final insumo = filtrados[index];

                        return Card(
                          child: ListTile(
                            leading: Icon(
                              Icons.circle,
                              color: colorStock(insumo.stock),
                              size: 18,
                            ),

                            title: Text(
                              insumo.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Stock: ${insumo.stock}",
                                  style: TextStyle(
                                    color: colorStock(insumo.stock),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(
                                  estadoStock(insumo.stock),
                                  style: TextStyle(
                                    color: colorStock(insumo.stock),
                                  ),
                                ),

                                Text(
                                  "Ubicación: ${insumo.ubicacion}",
                                ),
                              ],
                            ),

                            trailing: const Icon(Icons.chevron_right),

                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      InsumoDetalleScreen(insumo: insumo),
                                ),
                              );
                            },
                          ),
                        );

                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: rol == "ADMIN"
          ? FloatingActionButton(
              onPressed: _mostrarDialogo,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
