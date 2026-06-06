import 'package:flutter/material.dart';
import 'package:mi_app/routes/app_rutas.dart';
import 'package:mi_app/widgets/widgets_home/my_button.dart';

class MyBotonera extends StatelessWidget {
  const MyBotonera({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      //alineacion vertical (espacio entre los hijos)
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //alineacion Horizontal
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Panel principal",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryFixed,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: MyButton(
                  icono: Icons.person,
                  texto: "Usuarios",
                  onPressed: () {
                    print("estoy precionando mi botom 1");
                  },
                ),
              ),
              Center(
                child: MyButton(
                  icono: Icons.inventory_2,
                  texto: "Productos",
                  onPressed: () {
                    Navigator.pushNamed(context, AppRutas.nuevoProducto);
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: MyButton(
                  icono: Icons.shopping_cart,
                  texto: "Pedidos",
                  onPressed: () {
                    Navigator.pushNamed(context, AppRutas.crearPedido);
                  },
                ),
              ),
              Center(
                child: MyButton(
                  icono: Icons.assignment,
                  texto: "Reportes",
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: MyButton(
                  icono: Icons.store,
                  texto: "Stock",
                  onPressed: () {},
                ),
              ),
              Center(
                child: MyButton(
                  icono: Icons.inbox,
                  texto: "Insumos",
                  onPressed: () {
                    Navigator.pushNamed(context, AppRutas.insumos);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
