import 'package:flutter/material.dart';

class MyBottomBar extends StatelessWidget {
  const MyBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            print("Inicio");
          },
          icon: const Icon(Icons.home),
        ),

        IconButton(
          onPressed: () {
            print("Buscar");
          },

          icon: const Icon(Icons.assessment),
        ),

        IconButton(
          onPressed: () {
            print("Favoritos");
          },

          icon: const Icon(Icons.assignment),
        ),

        IconButton(
          onPressed: () {
            print("Perfil");
          },

          icon: const Icon(Icons.person),
        ),
      ],
    );
  }
}
