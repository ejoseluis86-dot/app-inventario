import 'package:flutter/material.dart';
import 'package:mi_app/screens/asociar_receta_screen.dart';

class NuevoProductoScreen extends StatefulWidget {
  const NuevoProductoScreen({super.key});

  @override
  State<NuevoProductoScreen> createState() => _NuevoProductoScreenState();
}

class _NuevoProductoScreenState extends State<NuevoProductoScreen> {
  final _nombreController = TextEditingController();
  final _precioController = TextEditingController();
  //esta sera estatica para siempre
  final List<String> categorias = [
      'Cerámica',
      'Plástico',
      'Metal',
      'Madera',
      'Papel',
      'Vidrio',
      'Textil'
  ];

  String? categoriaSeleccionada;

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nuevo Producto',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(height: 50),
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _precioController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: categoriaSeleccionada,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: categorias.map((categoria) {
                  return DropdownMenuItem(
                    value: categoria,
                    child: Text(categoria),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    categoriaSeleccionada = value;
                  });
                },
              ),
              const SizedBox(height: 200),
              //mensaje de advertencia
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondaryFixed,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: Colors.orange),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Al presionar Continuar, definirás los insumos teoricos necesarios para producir este articulo.',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 140),
              //    const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _continuar,
                  child: const Text(
                    'Continuar a Receta',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _continuar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AsociarRecetaScreen(
          nombreProducto: _nombreController.text,
          precioProducto: double.tryParse(_precioController.text) ?? 0,
          categoria: categoriaSeleccionada ?? '',
        ),
      ),
    );
  }
}
