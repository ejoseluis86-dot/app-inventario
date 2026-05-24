import 'package:flutter/material.dart';
import 'package:mi_app/widgets/my_button.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("holaaa")),
      body: Column(
        //alineacion vertical (espacio entre los hijos)
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //alineacion Horizontal
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: MyButton(
                    icono: Icons.person,
                    texto: "mi cuenta",
                    onPressed: () {},
                  ),
                ),
                Center(
                  child: MyButton(
                    icono: Icons.person,
                    texto: "mi cuenta",
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: MyButton(
                    icono: Icons.person,
                    texto: "mi cuenta",
                    onPressed: () {},
                  ),
                ),
                Center(
                  child: MyButton(
                    icono: Icons.person,
                    texto: "mi cuenta",
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: MyButton(
                    icono: Icons.person,
                    texto: "mi cuenta",
                    onPressed: () {},
                  ),
                ),
                Center(
                  child: MyButton(
                    icono: Icons.person,
                    texto: "mi cuenta",
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
