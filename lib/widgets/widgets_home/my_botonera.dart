import 'package:flutter/material.dart';
import 'package:mi_app/providers/user_provider.dart';
import 'package:mi_app/routes/app_rutas.dart';
import 'package:mi_app/widgets/widgets_home/my_button.dart';
import 'package:provider/provider.dart';

class MyBotonera extends StatelessWidget {
  const MyBotonera({super.key});

  @override
  Widget build(BuildContext context) {
    //rol del usuario
    final rol = context.watch<UserProvider>().rol;

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
                  texto: "Crear Usuario",
                  onPressed: () {
                    if (rol == 'ADMIN') {
                      Navigator.pushNamed(context, AppRutas.crearUsuario);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Usted no tiene los permisos para crear un usuario",
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              Center(
                child: MyButton(
                  icono: Icons.inventory_2,
                  texto: "Producto Nuevo",
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
                  texto: "Crear Pedido",
                  onPressed: () {
                    Navigator.pushNamed(context, AppRutas.crearPedido);
                  },
                ),
              ),
              Center(
                child: MyButton(
                  icono: Icons.assignment,
                  texto: "Area de Trabajo",
                  onPressed: () {
                    Navigator.pushNamed(context, AppRutas.trabajo);
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
        const SizedBox(height: 10),
      ],
    );
  }
}
