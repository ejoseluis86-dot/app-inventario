import 'package:flutter/material.dart';
import 'package:mi_app/services/api_service.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final ApiService api = ApiService();

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
          ],
        ),
      ),
    );
  }
}