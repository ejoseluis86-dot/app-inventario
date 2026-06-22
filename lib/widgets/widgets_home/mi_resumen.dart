import 'package:flutter/material.dart';
import 'package:mi_app/widgets/widgets_home/my_button_resumen.dart';

class MiResumen extends StatelessWidget {
  const MiResumen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      color: const Color(0xFFEDE7F6),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.dashboard_rounded,
                  color: color.primary,
                  size: 28,
                ),

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
              style: TextStyle(
                fontSize: 13,
                color: color.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: MyButtonResumen(
                    icono: Icons.warning_amber_rounded,
                    texto1: "Alerta de",
                    texto2: "Stock Crítico",
                    cantidad: 10,
                    onPressed: () {},
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: MyButtonResumen(
                    icono: Icons.assignment,
                    texto1: "Pedidos",
                    texto2: "Activos",
                    cantidad: 16,
                    onPressed: () {},
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