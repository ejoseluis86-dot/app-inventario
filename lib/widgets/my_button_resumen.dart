import 'package:flutter/material.dart';

class MyButtonResumen extends StatefulWidget {
  final IconData icono;
  final String texto1;
  final String texto2;
  final int cantidad;
  final VoidCallback onPressed;
  final Color color;

  const MyButtonResumen({
    super.key,
    required this.icono,
    required this.texto1,
    required this.texto2,
    required this.cantidad,
    required this.onPressed,
    required this.color,
  });

  @override
  State<MyButtonResumen> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButtonResumen> {
  bool presionado = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          presionado = true;
        });
      },

      onTapUp: (_) {
        setState(() {
          presionado = false;
        });

        widget.onPressed();
      },

      onTapCancel: () {
        setState(() {
          presionado = false;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),

        width: 130,
        height: 70,

        decoration: BoxDecoration(
          color: presionado
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,

          borderRadius: BorderRadius.circular(16),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(widget.icono, size: 40, color: Colors.white70),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.texto1,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.texto2,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.cantidad.toString(),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
