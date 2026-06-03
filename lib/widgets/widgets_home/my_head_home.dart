import 'package:flutter/material.dart';
import 'package:mi_app/widgets/widgets_home/mi_cabecera.dart';

class MyHeadHome extends StatelessWidget {
  const MyHeadHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Cabecera(),
        SizedBox(height: 5),
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage('assets/one_piece.jpg'),
            ),
            SizedBox(width: 10),
            Text(
              "nombre de usuario",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
