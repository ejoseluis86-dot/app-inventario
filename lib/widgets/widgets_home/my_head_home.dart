import 'package:flutter/material.dart';

class MyHeadHome extends StatelessWidget {
  const MyHeadHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(
                'assets/logo_empresa.png',
                width: 15,
                height: 40,
                scale: 1,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SZ Regalos Personalizados",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "@szsublimaciones",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
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
