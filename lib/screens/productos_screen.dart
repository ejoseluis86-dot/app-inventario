import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mi_app/providers/user_provider.dart';
import 'package:mi_app/routes/app_rutas.dart';
import 'package:mi_app/providers/producto_lite_provider.dart';
import 'package:mi_app/screens/producto_detalle_screen.dart';


class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  String search = "";
  String? filtroCategoria;

  @override
  Widget build(BuildContext context) {
    final productos = context.watch<ProductoLiteProvider>().productosLite;
    final rol = context.watch<UserProvider>().rol;

    final filtrados =
        productos.where((p) {
          final matchNombre = p.nombre.toLowerCase().contains(search);

          final matchCategoria =
              filtroCategoria == null || p.categoria == filtroCategoria;

          return matchNombre && matchCategoria;
        }).toList()
          ..sort(
            (a, b) =>
                a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
          );

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

                            title: Text(producto.nombre),

                            subtitle: Text(
                              "\$${producto.precio} • ${producto.categoria}",
                            ),

                            trailing: const Icon(Icons.chevron_right),

                            onTap: () {
                              final id = producto.id;
                              if (id == null) return;

                              print("Abriendo producto ${producto.id}");

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductoDetalleScreen(
                                    productoId: id,
                                  ),
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