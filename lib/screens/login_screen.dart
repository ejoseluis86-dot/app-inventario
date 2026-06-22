import 'package:flutter/material.dart';
import 'package:mi_app/providers/insumos_provider.dart';
import 'package:mi_app/providers/producto_lite_provider.dart';
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
    setState(() => cargando = true);

    try {
      final data = await authService.login(
        txtUsuario.text,
        txtPassword.text,
      );

      if (!mounted) return;

      final userProvider = context.read<UserProvider>();

      if (data != null) {
        userProvider.setUser(
          data['id'],
          data['nombre'],
          data['permiso'],
        );

        context.read<InsumoProvider>().cargarProviderInsumos();
        context.read<ProductoLiteProvider>().cargarProviderProductos();

        if (!mounted) return;

        Navigator.pushReplacementNamed(context, AppRutas.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario o contraseña incorrectos'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    if (!mounted) return;
    setState(() => cargando = false);
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
      body: Container(
        width: double.infinity,
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // LOGO
                    Image.asset(
                      'assets/sz2.png',
                      height: 160,
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 17),
                    const Text(
                      "Bienvenido, por favor inicie sesión",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // USUARIO
                    TextField(
                      controller: txtUsuario,
                      decoration: const InputDecoration(
                        labelText: 'Usuario',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // PASSWORD
                    _PasswordField(controller: txtPassword),

                    const SizedBox(height: 22),

                    // BOTÓN
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: cargando ? null : iniciarSesion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A1B9A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: cargando
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Ingresar",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 👁️ PASSWORD FIELD
class _PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const _PasswordField({required this.controller});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool oculto = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: oculto,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        prefixIcon: const Icon(Icons.lock),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            oculto ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() => oculto = !oculto);
          },
        ),
      ),
    );
  }
}