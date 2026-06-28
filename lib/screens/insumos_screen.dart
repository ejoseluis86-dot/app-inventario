import 'package:flutter/material.dart';
import 'package:mi_app/providers/insumos_provider.dart';
import 'package:mi_app/providers/user_provider.dart';
import 'package:mi_app/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:mi_app/screens/insumo_detalle_screen.dart';

class InsumosScreen extends StatefulWidget {
  final bool soloCriticos;

  const InsumosScreen({super.key, this.soloCriticos = false});

  @override
  State<InsumosScreen> createState() => _InsumosScreenState();
}

class _InsumosScreenState extends State<InsumosScreen> {
  final nombreController = TextEditingController();
  final stockController = TextEditingController();
  final ubicacionController = TextEditingController();

  final ApiService api = ApiService();

  String search = "";
  String filtroCategoria = "TODAS";
  String filtroStock = "TODOS";

  //muestra filtro de crticos desde pantalla principal  @override
  void initState() {
    super.initState();
  }

  void _mostrarDialogo() {
    final categorias = [
      'Cerámica',
      'Plástico',
      'Metal',
      'Madera',
      'Papel',
      'Vidrio',
      'Textil',
    ];

    String? categoria;
    bool loading = false;
    String? errorMensaje;
    String? errorNombre;
    final formKey = GlobalKey<FormState>();

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

              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (errorMensaje != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            errorMensaje!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    TextFormField(
                      controller: nombreController,
                      decoration: InputDecoration(
                        labelText: "Nombre",
                        prefixIcon: const Icon(Icons.inventory_2),
                        border: const OutlineInputBorder(),

                        // 👇 error del backend
                        errorText: errorNombre,
                      ),

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El nombre es obligatorio';
                        }
                        return null;
                      },

                      onChanged: (_) {
                        if (errorNombre != null) {
                          setStateDialog(() {
                            errorNombre = null;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Stock",
                        prefixIcon: Icon(Icons.numbers),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El stock es obligatorio';
                        }
                        if (int.tryParse(value.trim()) == null) {
                          return 'Debe ser un número válido';
                        }
                        return null;
                      },
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
                      validator: (value) {
                        if (value == null) {
                          return 'Selecciona una categoría';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setStateDialog(() {
                          categoria = value;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: ubicacionController,
                      decoration: const InputDecoration(
                        labelText: "Ubicación",
                        prefixIcon: Icon(Icons.place),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'La ubicación es obligatoria';
                        }
                        return null;
                      },
                    ),

                    if (loading)
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
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
                        setStateDialog(() {
                          errorMensaje = null;
                        });

                        if (!formKey.currentState!.validate()) {
                          return;
                        }

                        final stock = int.parse(stockController.text.trim());

                        setStateDialog(() => loading = true);

                        final error = await api.crearInsumo(
                          nombre: nombreController.text.trim(),
                          categoria: categoria!,
                          stock: stock,
                          ubicacion: ubicacionController.text.trim(),
                        );

                        setStateDialog(() => loading = false);

                        if (error != null) {
                          setStateDialog(() {
                            if (error.toLowerCase().contains("nombre")) {
                              errorNombre = error;
                            } else {
                              errorMensaje = error;
                            }
                          });
                          return;
                        }
                        await context.read<InsumoProvider>().cargarProviderInsumos();

                        if (mounted) Navigator.pop(context);

                        nombreController.clear();
                        stockController.clear();
                        ubicacionController.clear();
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

  final filtrados = insumos.where((i) {
    final nombre = i.nombre.toLowerCase();
    final matchSearch = nombre.contains(search);

    final matchCategoria =
    filtroCategoria == "TODAS" ||
    i.categoria == filtroCategoria;

    final matchStock =
        filtroStock == "TODOS" ||
        (filtroStock == "OK" && i.stock > 5) ||
        (filtroStock == "CRITICO" && i.stock > 2 && i.stock <= 5) ||
        (filtroStock == "URGENTE" && i.stock <= 2);

    return matchSearch && matchCategoria && matchStock;
  }).toList();

  return DefaultTabController(
    length: rol == "ADMIN" ? 2 : 1,
    child: Scaffold(
      appBar: AppBar(
        title: const Text("INSUMOS"),
        bottom: TabBar(
          tabs: [
            const Tab(text: "Activos"),
            if (rol == "ADMIN") const Tab(text: "Inactivos"),
          ],
        ),
      ),

          body: Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar insumo...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      search = value.toLowerCase();
                    });
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [

                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: filtroCategoria,
                        decoration: const InputDecoration(
                          labelText: "Categoría",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: "TODAS", child: Text("Todas")),
                          DropdownMenuItem(value: "Cerámica", child: Text("Cerámica")),
                          DropdownMenuItem(value: "Plástico", child: Text("Plástico")),
                          DropdownMenuItem(value: "Metal", child: Text("Metal")),
                          DropdownMenuItem(value: "Madera", child: Text("Madera")),
                          DropdownMenuItem(value: "Papel", child: Text("Papel")),
                          DropdownMenuItem(value: "Vidrio", child: Text("Vidrio")),
                          DropdownMenuItem(value: "Textil", child: Text("Textil")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            filtroCategoria = value ?? "TODAS";
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: filtroStock,
                        decoration: const InputDecoration(
                          labelText: "Estado",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: "TODOS", child: Text("Todos")),
                          DropdownMenuItem(value: "OK", child: Text("OK")),
                          DropdownMenuItem(value: "CRITICO", child: Text("Crítico")),
                          DropdownMenuItem(value: "URGENTE", child: Text("Urgente")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            filtroStock = value ?? "TODOS";
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: TabBarView(
                  children: [

                    RefreshIndicator(
                      onRefresh: () async {
                        await context.read<InsumoProvider>().cargarProviderInsumos();
                      },
                      child: _buildLista(
                        filtrados.where((i) => i.activo).toList(),
                      ),
                    ),

                    if (rol == "ADMIN")
                      RefreshIndicator(
                        onRefresh: () async {
                          await context.read<InsumoProvider>().cargarProviderInsumos();
                        },
                        child: _buildLista(
                          filtrados.where((i) => !i.activo).toList(),
                        ),
                      ),
                  ],
                ),
              ),
  ],
),

      floatingActionButton: rol == "ADMIN"
          ? FloatingActionButton(
              onPressed: _mostrarDialogo,
              child: const Icon(Icons.add),
            )
          : null,
    ),
  );
}
  Widget _buildLista(List insumosList) {
  if (insumosList.isEmpty) {
    return const Center(
      child: Text(
        "No hay insumos",
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  return ListView.separated(
    padding: const EdgeInsets.all(12),
    itemCount: insumosList.length,
    separatorBuilder: (_, __) => const SizedBox(height: 8),
    itemBuilder: (context, index) {
      final insumo = insumosList[index];

      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),

          leading: CircleAvatar(
            radius: 10,
            backgroundColor: colorStock(insumo.stock),
          ),

          title: Text(
            insumo.nombre,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Categoría: ${insumo.categoria}"),
              Text("Stock: ${insumo.stock}"),
              Text("Ubicación: ${insumo.ubicacion}"),
              Text(
                estadoStock(insumo.stock),
                style: TextStyle(
                  color: colorStock(insumo.stock),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          trailing: const Icon(Icons.chevron_right),

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InsumoDetalleScreen(
                  insumo: insumo,
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
}