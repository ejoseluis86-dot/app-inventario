import 'package:flutter/material.dart';
import 'package:mi_app/models/producto_lite.dart';

class ProductoDetalleScreen extends StatelessWidget {
  final ProductoLite producto;

  const ProductoDetalleScreen({
    super.key,
    required this.producto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(producto.nombre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "Precio: \$${producto.precio.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 10),

                Text(
                  "Categoría: ${producto.categoria}",
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 30),

                const Divider(),

                const SizedBox(height: 10),

                const Text(
                  "Receta",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                const Center(
                  child: Text(
                    "Aquí mostraremos los insumos de la receta.",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}