import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mi_app/providers/producto_lite_provider.dart';
import 'package:mi_app/providers/user_provider.dart';
import 'package:mi_app/models/producto_lite.dart';
import 'package:mi_app/screens/nuevo_producto_screen.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  final buscador = TextEditingController();

  String categoria = "Todas";

  final categorias = [
    "Todas",
    "Cerámica",
    "Plástico",
    "Metal",
    "Madera",
    "Papel",
    "Vidrio",
    "Textil",
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProductoLiteProvider>().cargarProviderProductos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductoLiteProvider>();

    final rol = context.watch<UserProvider>().rol;

    List<ProductoLite> lista = provider.productosLite;

    if (categoria != "Todas") {
      lista = lista
          .where((e) => e.categoria == categoria)
          .toList();
    }

    if (buscador.text.isNotEmpty) {
      lista = lista.where((e) {
        return e.nombre.toLowerCase().contains(
              buscador.text.toLowerCase(),
            );
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
      ),

      floatingActionButton: rol == "ADMIN"
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text("Nuevo"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NuevoProductoScreen(),
                  ),
                );
              },
            )
          : null,

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: buscador,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Buscar producto...",
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: categoria,
              decoration: const InputDecoration(
                labelText: "Categoría",
              ),
              items: categorias
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() {
                  categoria = v!;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (_, i) {
                final producto = lista[i];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(producto.nombre[0]),
                    ),

                    title: Text(producto.nombre),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("\$ ${producto.precio.toStringAsFixed(2)}"),
                        Text(producto.categoria),
                      ],
                    ),

                    trailing: const Icon(Icons.chevron_right),

                    onTap: () {
                      // siguiente paso
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}