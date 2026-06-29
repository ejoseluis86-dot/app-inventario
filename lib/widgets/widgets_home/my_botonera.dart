import 'package:flutter/material.dart';
import 'package:mi_app/providers/user_provider.dart';
import 'package:mi_app/routes/app_rutas.dart';
import 'package:provider/provider.dart';

class MyBotonera extends StatelessWidget {
  const MyBotonera({super.key});

  Widget _card(BuildContext context,
      {required IconData icono,
      required String texto,
      required VoidCallback onTap}) {
    final color = Theme.of(context).colorScheme;

    return Card(
      elevation: 6,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
          
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icono,
                  size: 30,
                  color: color.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                texto,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _cards(String? rol, BuildContext context) {
    final items = <Widget>[];

    if (rol == "ADMIN") {
      items.add(_card(
        context,
        icono: Icons.people, // 👈 Cambiamos a Icons.people que queda mejor para gestión
        texto: "Usuarios",
        onTap: () => Navigator.pushNamed(context, AppRutas.usuarios), // 👈 Cambiamos a tu nueva ruta
      ));
    }

    items.addAll([
      _card(
        context,
        icono: Icons.inventory_2,
        texto: "Productos",
        onTap: () => Navigator.pushNamed(context, AppRutas.productos),
      ),
      _card(
        context,
        icono: Icons.shopping_cart,
        texto: "Pedidos",
        onTap: () => Navigator.pushNamed(context, AppRutas.crearPedido),
      ),
      _card(
        context,
        icono: Icons.inbox,
        texto: "Insumos",
        onTap: () => Navigator.pushNamed(context, AppRutas.insumos),
      ),
    ]);

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final rol = context.watch<UserProvider>().rol;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1,
      children: _cards(rol, context),
    );
  }
}