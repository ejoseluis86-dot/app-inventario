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
  String filtroCategoria = "TODAS";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final esAdmin = context.read<UserProvider>().rol == "ADMIN";
      context.read<ProductoLiteProvider>().cargarProviderProductos(esAdmin);
    });
  }

  String _normalizar(String texto) {
    return texto
        .trim()
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ñ', 'n');
  }

  @override
  Widget build(BuildContext context) {
    final productos = context.watch<ProductoLiteProvider>().productosLite;
    final rol = context.watch<UserProvider>().rol;
    final esAdmin = rol == "ADMIN";

    // 1. Filtrado Base por buscador y dropdown de categoría
    final filtradosBase = productos.where((p) {
      final nombre = _normalizar(p.nombre);
      final busqueda = _normalizar(search);
      final matchSearch = nombre.contains(busqueda);
      final matchCategoria = filtroCategoria == "TODAS" || p.categoria == filtroCategoria;

      return matchSearch && matchCategoria;
    }).toList();

    // 2. Separación y ordenamiento alfabético para las pestañas
    final activosOrdenados = filtradosBase.where((p) => p.activo).toList()
      ..sort((a, b) => _normalizar(a.nombre).compareTo(_normalizar(b.nombre)));

    final inactivosOrdenados = filtradosBase.where((p) => !p.activo).toList()
      ..sort((a, b) => _normalizar(a.nombre).compareTo(_normalizar(b.nombre)));

    // CONTENIDO DEL CUERPO (Compartido dinámicamente)
    Widget cuerpoPantalla() {
      return Column(
        children: [
          // Buscador elegante
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar producto...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => setState(() => search = value),
            ),
          ),
          // Filtro por Categoría
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: filtroCategoria,
              decoration: const InputDecoration(labelText: "Categoría", border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: "TODAS", child: Text("Todas las categorías")),
                DropdownMenuItem(value: "Cerámica", child: Text("Cerámica")),
                DropdownMenuItem(value: "Plástico", child: Text("Plástico")),
                DropdownMenuItem(value: "Metal", child: Text("Metal")),
                DropdownMenuItem(value: "Madera", child: Text("Madera")),
                DropdownMenuItem(value: "Papel", child: Text("Papel")),
                DropdownMenuItem(value: "Vidrio", child: Text("Vidrio")),
                DropdownMenuItem(value: "Textil", child: Text("Textil")),
              ],
              onChanged: (value) => setState(() => filtroCategoria = value ?? "TODAS"),
            ),
          ),
          const SizedBox(height: 10),
          // Listado Dinámico usando TabBarView o Vista Directa
          Expanded(
            child: esAdmin
                ? TabBarView(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async => await context.read<ProductoLiteProvider>().cargarProviderProductos(esAdmin),
                        child: _buildLista(activosOrdenados),
                      ),
                      RefreshIndicator(
                        onRefresh: () async => await context.read<ProductoLiteProvider>().cargarProviderProductos(esAdmin),
                        child: _buildLista(inactivosOrdenados),
                      ),
                    ],
                  )
                : RefreshIndicator(
                    onRefresh: () async => await context.read<ProductoLiteProvider>().cargarProviderProductos(esAdmin),
                    child: _buildLista(activosOrdenados),
                  ),
          ),
        ],
      );
    }

    // INTERFAZ DE ADMINISTRADOR: Con pestañas
    if (esAdmin) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("PRODUCTOS", style: TextStyle(fontWeight: FontWeight.bold)),
            bottom: const TabBar(
              tabs: [
                Tab(text: "Activos"),
                Tab(text: "Inactivos"),
              ],
            ),
          ),
          body: cuerpoPantalla(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, AppRutas.nuevoProducto),
            child: const Icon(Icons.add),
          ),
        ),
      );
    }

    // INTERFAZ DE EMPLEADO: Limpia y sin pestañas arriba
    return Scaffold(
      appBar: AppBar(
        title: const Text("PRODUCTOS", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: cuerpoPantalla(),
    );
  }

  // Constructor de listas optimizado
  Widget _buildLista(List productosList) {
    if (productosList.isEmpty) {
      return const Center(child: Text("No hay productos", style: TextStyle(fontSize: 18)));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: productosList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final p = productosList[index];
        final id = p.id;
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            title: Text(p.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Categoría: ${p.categoria} \nPrecio: \$${p.precio}"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              if (id == null) return;
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProductoDetalleScreen(productoId: id)),
              );
              if (mounted) {
                final esAdmin = context.read<UserProvider>().rol == "ADMIN";
                await context.read<ProductoLiteProvider>().cargarProviderProductos(esAdmin);
              }
            },
          ),
        );
      },
    );
  }
}