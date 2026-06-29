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

    final nombreCompleto =
        "${user.nombre ?? user.username ?? ''} ${user.apellido ?? ''}".trim();

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

        // ---------------- LOGO + TITULO ----------------
        title: Row(
          children: [
            // LOGO
            Image.asset(
              "assets/sz_3.png",
              height: 33,
            ),

            

            // TITULO
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "SZ App",
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
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),

        // ---------------- USUARIO + ACCIONES ----------------
// ---------------- USUARIO + ACCIONES ----------------
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TEXTO USUARIO (¡Se queda firme acá!)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      nombreCompleto.isEmpty ? "Usuario" : nombreCompleto,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      user.rol == "ADMIN" ? "Administrador" : "Empleado",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(width: 10),

                // 🔮 BOTÓN PERFIL CON AVATAR DINÁMICO
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.pushNamed(context, AppRutas.perfil);
                  },
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: const Color(0xFF6A1B9A), // Tu violeta institucional
                    child: Text(
                      (user.nombre != null && user.nombre!.isNotEmpty)
                          ? user.nombre![0].toUpperCase()
                          : (user.username != null && user.username!.isNotEmpty)
                              ? user.username![0].toUpperCase()
                              : "U",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // LOGOUT
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

      // ---------------- BODY ----------------
      body: Builder(
        builder: (context) {
          final isDark =
              Theme.of(context).brightness == Brightness.dark;

          return Stack(
            children: [

              // FONDO SOLO EN modo claro

              if (!isDark)
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF6A1B9A), Color(0xFFEDE7F6)],
                    ),
                  ),
                )
              else
                // 🌑 FONDO DARK NORMAL DEL THEME
                Container(color: Theme.of(context).scaffoldBackgroundColor),

              const SingleChildScrollView(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
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
