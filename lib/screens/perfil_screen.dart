import 'package:flutter/material.dart';
import 'package:mi_app/services/api_service.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final ApiService api = ApiService();
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final usernameController = TextEditingController();


  bool loading = true;
  Map<String, dynamic>? usuario;

  @override
  void initState() {
    super.initState();
    cargarPerfil();
  }



  Future<void> cargarPerfil() async {
    try {
      final data = await api.obtenerMiPerfil();

      setState(() {
        usuario = data;
        loading = false;
      });
    } catch (e) {
      print("ERROR PERFIL: $e");
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _mostrarDialogoEditar() async {
    nombreController.text = usuario?['nombre'] ?? "";
    apellidoController.text = usuario?['apellido'] ?? "";
    usernameController.text = usuario?['username'] ?? "";

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar perfil"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Usuario",
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: "Nombre",
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: apellidoController,
                decoration: const InputDecoration(
                  labelText: "Apellido",
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Rol: ${usuario?['rol']}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancelar"),
            ),

            ElevatedButton(
              onPressed: () async {

                final actualizado =
                    await api.actualizarMiPerfil(
                  nombre: nombreController.text,
                  apellido: apellidoController.text,
                  username: usernameController.text,
                );

                Navigator.pop(context, actualizado);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );

    if (ok == true) {
      await cargarPerfil();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Perfil actualizado"),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Mi perfil")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Usuario: ${usuario?['username']}"),
            Text("Nombre: ${usuario?['nombre']}"),
            Text("Apellido: ${usuario?['apellido']}"),
            Text("Rol: ${usuario?['rol']}"),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("Editar perfil"),
              onPressed: () {
                _mostrarDialogoEditar();
              },
            ),
          ],
        ),
      ),
    );
  }
}