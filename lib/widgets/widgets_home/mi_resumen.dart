import 'package:flutter/material.dart';
import 'package:mi_app/widgets/widgets_home/my_button_resumen.dart';

class MiResumen extends StatelessWidget {
  const MiResumen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).focusColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            "Resumen Rapido",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryFixed,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MyButtonResumen(
                icono: Icons.dangerous,
                texto1: "Alerta de",
                texto2: "Stock Crítico",
                cantidad: 10,
                onPressed: () {},
                color: Colors.pinkAccent,
              ),
              MyButtonResumen(
                icono: Icons.assignment,
                texto1: "Pedidos",
                texto2: "Activos",
                cantidad: 16,
                onPressed: () {},
                color: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
