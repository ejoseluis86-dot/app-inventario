import 'package:flutter/material.dart';
import 'package:mi_app/services/api_service.dart';

class CrearUsuarioScreen extends StatefulWidget {
  const CrearUsuarioScreen({super.key});

  @override
  State<CrearUsuarioScreen> createState() => _CrearUsuarioScreenState();
}

class _CrearUsuarioScreenState extends State<CrearUsuarioScreen> {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  String rolSeleccionado = "EMPL";
  bool loading = false;

  final ApiService api = ApiService();

  Future<void> crearUsuario() async {
    setState(() => loading = true);

    final ok = await api.crearUsuario(
      username: usernameCtrl.text,
      password: passwordCtrl.text,
      rol: rolSeleccionado,
    );

    setState(() => loading = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuario creado correctamente")),
      );

      usernameCtrl.clear();
      passwordCtrl.clear();
      setState(() => rolSeleccionado = "EMPL");
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error al crear usuario")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear Usuario")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // USERNAME
            TextField(
              controller: usernameCtrl,
              decoration: const InputDecoration(
                labelText: "Usuario",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // PASSWORD
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // ROL
            DropdownButtonFormField<String>(
              initialValue: rolSeleccionado,
              items: const [
                DropdownMenuItem(value: "ADMIN", child: Text("ADMIN")),
                DropdownMenuItem(value: "EMPL", child: Text("EMPLEADO")),
              ],
              onChanged: (value) {
                setState(() {
                  rolSeleccionado = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Rol",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // BOTÓN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : crearUsuario,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Crear usuario"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
