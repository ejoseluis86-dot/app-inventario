import 'package:flutter/material.dart';
import 'package:mi_app/widgets/widgets_home/my_botonera.dart';
import 'package:mi_app/widgets/widgets_home/mi_resumen.dart';
import 'package:mi_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:mi_app/routes/app_rutas.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: false,

      // ---------------- APPBAR ----------------
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        elevation: 4,
        title: Row(
          children: [
            Image.asset(
              "assets/logo_empresa.png",
              height: 42,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Sistema de Inventario",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.3,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Panel de gestión",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      
                      user.username ?? "Usuario",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      user.rol == "ADMIN"
                          ? "Administrador"
                          : "Empleado",
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 8),

                CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 18,
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    context.read<UserProvider>().clearUser();

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRutas.login,
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      // ---------------- BODY ORDENADO ----------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: const [
            MiResumen(),
            SizedBox(height: 12),
            MyBotonera(),
          ],
        ),
      ),
    );
  }
}