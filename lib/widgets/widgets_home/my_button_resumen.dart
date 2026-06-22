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
  State<MyButtonResumen> createState() => _MyButtonResumenState();
}

class _MyButtonResumenState extends State<MyButtonResumen> {
  bool presionado = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: (_) => setState(() => presionado = true),

      onTapUp: (_) {
        setState(() => presionado = false);
        widget.onPressed();
      },

      onTapCancel: () => setState(() => presionado = false),

      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: presionado ? 0.97 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),

          height: 120,

          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    widget.icono,
                    color: widget.color,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.texto1,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),

                      Text(
                        widget.texto2,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        widget.cantidad.toString(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: widget.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}