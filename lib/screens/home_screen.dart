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
<<<<<<< HEAD
            Image.asset(
              "assets/sz_3.png",
              height: 33,
            ),
=======
            Image.asset("assets/sz_3.png", height: 33),

>>>>>>> 8ecd674d5c05e2f022aac16b65a39338fa9cda67
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
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),

        // ---------------- USUARIO + ACCIONES ----------------
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TEXTO USUARIO
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      nombreCompleto.isEmpty ? "Usuario" : nombreCompleto,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      user.rol == "ADMIN" ? "Administrador" : "Empleado",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),

                const SizedBox(width: 10),

<<<<<<< HEAD
                // BOTÓN PERFIL
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.pushNamed(context, AppRutas.perfil);
                  },
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 18,
                    ),
=======
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 18,
>>>>>>> 8ecd674d5c05e2f022aac16b65a39338fa9cda67
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
<<<<<<< HEAD
=======
              // FONDO SOLO EN modo claro
>>>>>>> 8ecd674d5c05e2f022aac16b65a39338fa9cda67
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
<<<<<<< HEAD
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
=======
                // 🌑 FONDO DARK NORMAL DEL THEME
                Container(color: Theme.of(context).scaffoldBackgroundColor),
>>>>>>> 8ecd674d5c05e2f022aac16b65a39338fa9cda67

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
