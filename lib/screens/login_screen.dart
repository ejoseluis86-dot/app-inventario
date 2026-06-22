import 'package:flutter/material.dart';
import 'package:mi_app/providers/insumos_provider.dart';
import 'package:mi_app/providers/user_provider.dart';
import 'package:mi_app/routes/app_rutas.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController txtUsuario = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  final AuthService authService = AuthService();

  bool cargando = false;

  Future<void> iniciarSesion() async {
    setState(() {
      cargando = true;
    });

    try {
      //hacemos la peticion y traemos el token
      final data = await authService.login(txtUsuario.text, txtPassword.text);

      if (!mounted) return;

      final userProvider = context.read<UserProvider>();

      if (data != null) {
        //aca cargo el providerUser con los datos del token que esta en data
        userProvider.setUser(data['id'], data['nombre'], data['permiso']);
        //tambien creo los providers y sus peticiones
        final insumosProvider = context.read<InsumoProvider>();
        insumosProvider.cargarProviderInsumos();
        if (!mounted) return;

        Navigator.pushReplacementNamed(context, AppRutas.home);
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario o contraseña incorrectos')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    if (!mounted) return;

    setState(() {
      cargando = false;
    });
  }

  @override
  void dispose() {
    txtUsuario.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 30),

            TextField(
              controller: txtUsuario,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: txtPassword,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cargando ? null : iniciarSesion,
                child: cargando
                    ? const CircularProgressIndicator()
                    : const Text('Ingresar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
