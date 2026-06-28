import 'package:flutter/material.dart';
import 'package:mi_app/models/producto.dart';
import 'package:mi_app/services/api_service.dart';
import 'package:mi_app/screens/editar_producto_screen.dart';

class ProductoDetalleScreen extends StatefulWidget {
  final int productoId;

  const ProductoDetalleScreen({
    super.key,
    required this.productoId,
  });

  @override
  State<ProductoDetalleScreen> createState() => _ProductoDetalleScreenState();
}

class _ProductoDetalleScreenState extends State<ProductoDetalleScreen> {
  final ApiService api = ApiService();

  Producto? producto;
  bool loading = true;
  bool error = false;

  @override
  void initState() {
    super.initState();
    cargarProducto();
  }

  Future<void> cargarProducto() async {
    try {
      setState(() {
        loading = true;
        error = false;
      });

      final data = await api.obtenerProducto(widget.productoId);

      setState(() {
        producto = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        error = true;
      });

      print("❌ Error cargando producto: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error || producto == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Error al cargar producto"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: cargarProducto,
                child: const Text("Reintentar"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(producto!.nombre),

        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditarProductoScreen(producto: producto!),
                ),
              );
            },
          ),
        ],  
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nombre: ${producto!.nombre}",
              style: const TextStyle(fontSize: 18),
            ),
            Text("Precio: \$${producto!.precio}"),
            Text("Categoría: ${producto!.categoria}"),

            const SizedBox(height: 20),

            const Text(
              "Receta:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: producto!.detalles?.length ?? 0,
                itemBuilder: (context, index) {
                  final d = producto!.detalles![index];

                  return ListTile(
                    title: Text(d.nombreInsumo ?? "Insumo"),
                    subtitle: Text(
                      "Cantidad: ${d.cantidadTeorica}",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}