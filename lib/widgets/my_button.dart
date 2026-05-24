import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final IconData icono;
  final String texto;
  final VoidCallback onPressed;

  const MyButton({
    super.key,
    required this.icono,
    required this.texto,
    required this.onPressed,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
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

        width: 120,
        height: 120,

        decoration: BoxDecoration(
          color: presionado
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,

          borderRadius: BorderRadius.circular(16),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icono, size: 40, color: Colors.white),

            const SizedBox(height: 10),

            Text(widget.texto, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
