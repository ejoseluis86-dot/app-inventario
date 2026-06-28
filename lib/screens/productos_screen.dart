import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mi_app/providers/user_provider.dart';
import 'package:mi_app/routes/app_rutas.dart';
import 'package:mi_app/providers/producto_lite_provider.dart';
import 'package:mi_app/screens/producto_detalle_screen.dart';
import 'package:mi_app/services/api_service.dart';


class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  String search = "";
  String? filtroCategoria;
  bool mostrarInactivos = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final esAdmin =
          context.read<UserProvider>().rol == "ADMIN";

      context
          .read<ProductoLiteProvider>()
          .cargarProviderProductos(esAdmin);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productos = context.watch<ProductoLiteProvider>().productosLite;
    final userProvider = context.watch<UserProvider>();
    final esAdmin = userProvider.rol == "ADMIN";
  

    final filtrados = productos.where((p) {
      final matchNombre = p.nombre.toLowerCase().contains(search);

      final matchCategoria =
          filtroCategoria == null || p.categoria == filtroCategoria;

      final matchActivo = esAdmin
          ? (mostrarInactivos ? true : p.activo)
          : p.activo;

      return matchNombre && matchCategoria && matchActivo;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("PRODUCTOS"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          children: [

            TextField(
              decoration: const InputDecoration(
                labelText: "Buscar producto",
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
                labelText: "Categoría",
                prefixIcon: Icon(Icons.filter_list),
                border: OutlineInputBorder(),
              ),
              items: const [

                DropdownMenuItem(
                  value: null,
                  child: Text("Todas"),
                ),

                DropdownMenuItem(
                  value: "Cerámica",
                  child: Text("Cerámica"),
                ),

                DropdownMenuItem(
                  value: "Plástico",
                  child: Text("Plástico"),
                ),

                DropdownMenuItem(
                  value: "Metal",
                  child: Text("Metal"),
                ),

                DropdownMenuItem(
                  value: "Madera",
                  child: Text("Madera"),
                ),

                DropdownMenuItem(
                  value: "Papel",
                  child: Text("Papel"),
                ),

                DropdownMenuItem(
                  value: "Vidrio",
                  child: Text("Vidrio"),
                ),

                DropdownMenuItem(
                  value: "Textil",
                  child: Text("Textil"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  filtroCategoria = value;
                });
              },
            ),

            const SizedBox(height: 12),

            Expanded(
              child: filtrados.isEmpty
                  ? const Center(
                      child: Text("No hay productos"),
                    )
                  : ListView.builder(
                      itemCount: filtrados.length,
                      itemBuilder: (_, index) {
                        final producto = filtrados[index];

                        print( "Fila $index -> id=${producto.id} nombre=${producto.nombre}", );                 

                        return Card(
                          key: ValueKey(producto.id),
                          child: ListTile(
                            leading: const Icon(Icons.inventory_2),

                            title: Text(
                              producto.nombre,
                              style: TextStyle(
                                color: producto.activo ? Colors.black : Colors.grey,
                                fontWeight: producto.activo ? FontWeight.normal : FontWeight.bold,
                              ),
                            ),

                            subtitle: Text(
                              "\$${producto.precioFormateado} • ${producto.categoria}"
                            ),

                            trailing: esAdmin
                              ? IconButton(
                                  icon: Icon(
                                    producto.activo ? Icons.toggle_on : Icons.toggle_off,
                                    color: producto.activo ? Colors.green : Colors.red,
                                  ),
                                  onPressed: () async {
                                    await context
                                        .read<ApiService>()
                                        .toggleProducto(producto.id!);

                                    await context
                                        .read<ProductoLiteProvider>()
                                        .cargarProviderProductos(true);
                                  },
                                )
                              : const Icon(Icons.chevron_right),

                            onTap: () async {
                              final id = producto.id;
                              if (id == null) return;

                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductoDetalleScreen(productoId: id),
                                ),
                              );

                              // REFRESCAR LISTA AL VOLVER
                              final esAdmin = context.read<UserProvider>().rol == "ADMIN";

                              await context
                                  .read<ProductoLiteProvider>()
                                  .cargarProviderProductos(esAdmin);
                            },
                          ),
                        );
                      },
                    ),
            ),
            SwitchListTile(
              title: const Text("Ver inactivos"),
              value: mostrarInactivos,
              onChanged: (value) {
                setState(() {
                  mostrarInactivos = value;
                });
              },
            ),
          ],
          
        ),
      ),
      floatingActionButton: esAdmin
        ? FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRutas.nuevoProducto,
              );
            },
            child: const Icon(Icons.add),
          )
        : null,
    );
  }
}