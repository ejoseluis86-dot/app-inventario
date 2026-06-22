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
      backgroundColor: Colors.transparent,

      // ---------------- APPBAR ----------------
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surface
            : Colors.white.withOpacity(0.92),

        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shadowColor: Colors.black26,
        automaticallyImplyLeading: false,
        toolbarHeight: 90,

        title: Row(
          children: [
            Image.asset(
              "assets/sz_3.png",
              height: 33,
            ),

            const SizedBox(width: 10),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),

                const SizedBox(width: 8),

                CircleAvatar(
                  radius: 16,
                  backgroundColor:
                      Theme.of(context).colorScheme.primary,
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

      // ---------------- BODY CON DEGRADÉ ----------------
      body: Builder(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Stack(
            children: [

              // FONDO SOLO EN modo claro
              if (!isDark)
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF6A1B9A),
                        Color(0xFFEDE7F6),
                      ],
                    ),
                  ),
                )
              else
                // 🌑 FONDO DARK NORMAL DEL THEME
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),

              // 📱 CONTENIDO
              SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: const [
                    MiResumen(),
                    SizedBox(height: 12),
                    MyBotonera(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}