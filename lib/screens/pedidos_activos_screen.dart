import 'package:flutter/material.dart';
import 'package:mi_app/services/api_service.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  late Future<List<dynamic>> _listaPedidos;

  @override
  void initState() {
    super.initState();
    _listaPedidos = ApiService().obtenerPedidosLite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 💡 Se eliminó el color hardcodeado para que tome el scaffoldBackgroundColor del AppTheme
      body: CustomScrollView(
        slivers: [
          // 1. App Bar limpia y unificada con Insumos/Productos
          _buildModernAppBar(context),

          // 2. Sección de Resumen (Contadores rápidos)
          SliverToBoxAdapter(
            child: _buildSummarySection(context),
          ),

          // 3. Lista de Pedidos
          SliverFillRemaining(
            child: FutureBuilder<List<dynamic>>(
              future: _listaPedidos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return _buildErrorState(snapshot.error.toString());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                final pedidos = snapshot.data!;
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _listaPedidos = ApiService().obtenerPedidosLite();
                    });
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    itemCount: pedidos.length,
                    itemBuilder: (context, index) {
                      return _buildOrderCard(context, pedidos[index]);
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

  // --- COMPONENTES UI ADAPTADOS AL THEME ---

  Widget _buildModernAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SliverAppBar(
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      title: Text(
        "PEDIDOS",
        style: TextStyle(
          fontWeight: FontWeight.bold, 
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildStatCard("Activos", "12", Icons.timer, Colors.orange),
          const SizedBox(width: 12),
          _buildStatCard("Hoy", "45", Icons.trending_up, Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1), 
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // 🔄 CORREGIDO: Mantiene tu firma limpia original recibiendo el objeto dynamic 'pedido'
  Widget _buildOrderCard(BuildContext context, dynamic pedido) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () { /* Detalle del pedido si hiciera falta */ },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Text(
                  pedido['cliente'] != null && pedido['cliente'].toString().isNotEmpty
                      ? pedido['cliente'][0].toUpperCase()
                      : "C",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Orden #${pedido['id']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(pedido['cliente'] ?? "Cliente", style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),
              // Botón Cerrar dinámico a la derecha
              _buildActionButton(pedido['id']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(int id) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade50,
        foregroundColor: Colors.green.shade700,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: () => _confirmarFinalizar(id),
      child: const Row(
        children: [
          Icon(Icons.done_all, size: 18),
          SizedBox(width: 5),
          Text("Cerrar", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _confirmarFinalizar(int idPedido) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Finalizar pedido?"),
        content: Text("Se procederá a cerrar la orden #$idPedido."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Lógica de cierre...
            }, 
            child: const Text("Confirmar", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_outlined, size: 70, color: Colors.grey),
          SizedBox(height: 12),
          Text("Todo al día", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
          Text("No hay pedidos pendientes", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(child: Text("Ocurrió un error: $error", style: const TextStyle(color: Colors.red)));
  }
}