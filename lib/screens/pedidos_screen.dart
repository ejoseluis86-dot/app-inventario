import 'package:flutter/material.dart';

import 'package:mi_app/services/api_service.dart';
import 'package:intl/intl.dart'; // Para formatear fechas de forma linda

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE), // Fondo suave tipo dashboard
      body: CustomScrollView(
        slivers: [
          // 1. App Bar Moderna con Diseño Curvo
          _buildModernAppBar(context),

          // 2. Sección de Resumen (Analytics rápido)
          SliverToBoxAdapter(
            child: _buildSummarySection(context),
          ),

          // 3. Lista de Pedidos con Animación de Carga
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

  // --- COMPONENTES UI MODERNOS ---

  Widget _buildModernAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: const Text(
          "Gestión de Pedidos",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.analytics_outlined, color: Colors.white),
          onPressed: () { /* Aquí iría pantalla de reportes */ },
        ),
      ],
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _buildStatCard("Activos", "12", Icons.timer, Colors.orange),
          const SizedBox(width: 15),
          _buildStatCard("Hoy", "45", Icons.trending_up, Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
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
    );
  }

  Widget _buildOrderCard(BuildContext context, dynamic pedido) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () { /* Navegar a detalle completo */ },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar con inicial del cliente
              CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Text(
                  pedido['cliente'][0].toUpperCase(),
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              // Info del Pedido
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Orden #${pedido['id']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(pedido['cliente'], style: TextStyle(color: Colors.grey.shade700)),
                  ],
                ),
              ),
              // Botón de Acción Moderno
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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

  // --- DIÁLOGOS Y ESTADOS ---

  void _confirmarFinalizar(int idPedido) {
    // falta lógica de cierre del pedido
  }

  Widget _buildEmptyState() {
    return const Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.assignment_turned_in_outlined, size: 80, color: Colors.grey),
        SizedBox(height: 16),
        Text("Todo al día", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
        Text("No hay pedidos pendientes por cerrar", style: TextStyle(color: Colors.grey)),
      ],
    ));
  }

  Widget _buildErrorState(String error) {
    return Center(child: Text("Ocurrió un error: $error"));
  }
}