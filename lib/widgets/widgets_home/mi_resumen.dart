import 'package:flutter/material.dart';
import 'package:mi_app/providers/insumos_provider.dart';
import 'package:mi_app/providers/pedido_lite_provider.dart';
import 'package:mi_app/routes/app_rutas.dart';
import 'package:mi_app/widgets/widgets_home/my_button_resumen.dart';
import 'package:provider/provider.dart';
import 'package:mi_app/screens/insumos_screen.dart';
import 'package:mi_app/screens/pedidos_generales_screen.dart';

class MiResumen extends StatelessWidget {
  const MiResumen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final insumos = context.watch<InsumoProvider>().insumos;
    final pedidos = context.watch<PedidoLiteProvider>().pedidosLite;

    return Card(
      elevation: 4,
      color: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.dashboard_rounded, color: color.primary, size: 28),

                const SizedBox(width: 10),

                Text(
                  "Resumen rápido",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color.onSurface,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              "Indicadores principales del sistema",
              style: TextStyle(fontSize: 13, color: color.onSurfaceVariant),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: MyButtonResumen(
                    icono: Icons.warning_amber_rounded,
                    texto1: "Alerta de",
                    texto2: "Stock Crítico",
                    //esto cuenta los insumos con stock <=5
                    cantidad: insumos.where((i) => i.stock <= 5).length,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const InsumosScreen(
                            abrirCriticos: true,
                          ),
                        ),
                      );
                    },
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: MyButtonResumen(
                    icono: Icons.assignment,
                    texto1: "Pedidos",
                    texto2: "Activos",
                    cantidad: pedidos.length,
                    onPressed: () {
                      // 1. Navegamos a una nueva pantalla (sin reemplazar la actual)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(title: const Text("Pedidos Activos")),
                            // 2. Usamos la clase pública que preparamos en pedidos_generales_screen.dart
                            body: const ListaPedidosGenerica(esTerminado: false), 
                          ),
                        ),
                      );
                    },
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
