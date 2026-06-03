import 'package:flutter/material.dart';

class AsociarRecetaScreen extends StatefulWidget {
  final String nombreProducto;

  const AsociarRecetaScreen({super.key, required this.nombreProducto});

  @override
  State<AsociarRecetaScreen> createState() => _AsociarRecetaScreenState();
}

class _AsociarRecetaScreenState extends State<AsociarRecetaScreen> {
  final TextEditingController cantidadController = TextEditingController();

  final List<String> insumos = [
    'Harina',
    'Azúcar',
    'Leche',
    'Huevos',
    'Chocolate',
  ];

  String? insumoSeleccionado;
  //esta es un alista de detalles que se usa para mostrar
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
          insumo: insumoSeleccionado!,
          cantidad: double.parse(cantidadController.text),
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
  void guardarReceta() {
    for (var detalle in detalles) {
      print('${detalle.insumo} - ${detalle.cantidad}');
    }
  }

  @override
  Widget build(BuildContext context) {
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

            DropdownButtonFormField<String>(
              initialValue: insumoSeleccionado,
              decoration: const InputDecoration(
                labelText: 'SeleccionarInsumo Base',
                border: OutlineInputBorder(),
              ),
              items: insumos.map((insumo) {
                return DropdownMenuItem(value: insumo, child: Text(insumo));
              }).toList(),
              onChanged: (value) {
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
                            title: Text(detalle.insumo),
                            subtitle: Text('Cantidad: ${detalle.cantidad}'),
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

class DetalleReceta {
  final String insumo;
  final double cantidad;

  DetalleReceta({required this.insumo, required this.cantidad});
}
