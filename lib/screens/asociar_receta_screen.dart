import 'package:flutter/material.dart';
import 'package:mi_app/models/detalle_receta.dart';
import 'package:mi_app/models/insumo.dart';
import 'package:mi_app/models/producto.dart';
import 'package:mi_app/providers/insumos_provider.dart';
import 'package:mi_app/routes/app_rutas.dart';
import 'package:mi_app/services/api_service.dart';
import 'package:provider/provider.dart';

class AsociarRecetaScreen extends StatefulWidget {
  final String nombreProducto;
  final double precioProducto;
  final String categoria;
  const AsociarRecetaScreen({
    super.key,
    required this.nombreProducto,
    required this.precioProducto,
    required this.categoria,
  });

  @override
  State<AsociarRecetaScreen> createState() => _AsociarRecetaScreenState();
}

class _AsociarRecetaScreenState extends State<AsociarRecetaScreen> {
  late final TextEditingController cantidadController = TextEditingController();

  Insumo? insumoSeleccionado;

  //esta es un alista de detalles que se usa para mostrar y crear la receta
  final List<DetalleReceta> detalles = [];

  @override
  void dispose() {
    //esto es para destruir los controladores de texto cuando ya no se necesiten, para liberar recursos
    cantidadController.dispose();
    super.dispose();
  }

  void agregarDetalle() {
    if (insumoSeleccionado == null || cantidadController.text.isEmpty) {
      return;
    }
    setState(() {
      detalles.add(
        //aca estoy creando un nuevo detalle de receta con el insumo seleccionado y la cantidad ingresada, y lo agrego a la lista de detalles
        DetalleReceta(
          cantidadTeorica: int.parse(cantidadController.text),
          insumoId: insumoSeleccionado!.id!,
        ),
      );
      cantidadController.clear();
      insumoSeleccionado = null;
    });
  }

  void eliminarDetalle(int index) {
    setState(() {
      detalles.removeAt(index);
    });
  }

  //esto no iria hay que modificar
  Future<void> guardarReceta() async {
    //creo un api service
    final apiService = ApiService();

    if (widget.nombreProducto.trim().isEmpty ||
        widget.categoria.trim().isEmpty ||
        widget.precioProducto <= 0 ||
        detalles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe completar todos los campos')),
      );
    } else {
      final Producto nuevoProducto = Producto(
        nombre: widget.nombreProducto,
        precio: widget.precioProducto,
        categoria: widget.categoria,
        detalles: detalles,
      );
      //uso el api service para guardar el producto
      bool ok = await apiService.crearProducto(nuevoProducto);
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Producto creado exitosamente"),
            backgroundColor: Colors.green,
          ),
        );

        // esperar un poco y redirigir
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushNamed(context, AppRutas.home);
        });
      }

      //faltaria actualizar el provider de Productos Lite
    }
  }

  @override
  Widget build(BuildContext context) {
    //aca estoy trayendo una lista de insumos desde el provider
    final insumosBD = context.watch<InsumoProvider>().insumos;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Asociar Receta',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.nombreProducto,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<Insumo>(
              initialValue: insumoSeleccionado,

              decoration: const InputDecoration(
                labelText: 'Seleccionar Insumo Base',
                border: OutlineInputBorder(),
              ),

              items: insumosBD.map((insumo) {
                return DropdownMenuItem<Insumo>(
                  value: insumo,
                  child: Text(insumo.nombre),
                );
              }).toList(),

              onChanged: (Insumo? value) {
                setState(() {
                  insumoSeleccionado = value;
                });
              },
            ),

            const SizedBox(height: 12),

            TextField(
              controller: cantidadController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Cantidad Teorica Requerida',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: agregarDetalle,
                icon: const Icon(Icons.add),
                label: const Text('Agregar'),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: detalles.isEmpty
                  ? const Center(child: Text('No hay detalles agregados'))
                  : ListView.builder(
                      itemCount: detalles.length,
                      itemBuilder: (context, index) {
                        final detalle = detalles[index];

                        return Card(
                          child: ListTile(
                            title: Text(
                              insumosBD
                                  .firstWhere(
                                    (insumo) => insumo.id == detalle.insumoId,
                                  )
                                  .nombre,
                            ),
                            subtitle: Text(
                              'Cantidad: ${detalle.cantidadTeorica}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => eliminarDetalle(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: guardarReceta,
                child: const Text('GUARDAR RECETA COMPLETA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
