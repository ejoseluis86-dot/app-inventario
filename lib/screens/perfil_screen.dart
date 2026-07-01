import 'package:flutter/material.dart';
import 'package:mi_app/services/api_service.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final ApiService api = ApiService();
  
  // Controladores exclusivos para el cambio de contraseña
  final actualController = TextEditingController();
  final nuevaController = TextEditingController();
  final repetirController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool loading = true;
  Map<String, dynamic>? usuario;

  // Color idem Login y Botones
  final Color colorVioletaCorporativo = const Color(0xFF6A1B9A);

  @override
  void initState() {
    super.initState();
    cargarPerfil();
  }

  @override
  void dispose() {
    actualController.dispose();
    nuevaController.dispose();
    repetirController.dispose();
    super.dispose();
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

  // Diálogo Seguro para cambiar la contraseña
  void _mostrarDialogoCambiarPassword() {
    actualController.clear();
    nuevaController.clear();
    repetirController.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.lock, color: colorVioletaCorporativo),
              const SizedBox(width: 10),
              const Text("Cambiar Contraseña", style: TextStyle(fontSize: 20)),
            ],
          ),
          content: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction, // 🌟 Desvanece el error dinámicamente al escribir
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: actualController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Contraseña Actual",
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty ? "Ingresá tu clave actual" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nuevaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Nueva Contraseña",
                      prefixIcon: Icon(Icons.lock_reset),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Ingresá la nueva clave";
                      if (value.length < 6) return "Debe tener al menos 6 caracteres";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: repetirController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Repetir Nueva Contraseña",
                      prefixIcon: Icon(Icons.gpp_good_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Repetí la nueva clave";
                      if (value != nuevaController.text) return "Las contraseñas no coinciden";
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar", style: TextStyle(color: colorVioletaCorporativo)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorVioletaCorporativo,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;

                // falta implementar el endpoint en Django 
                String? error; 

                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error), backgroundColor: Colors.red),
                  );
                  return;
                }

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Contraseña actualizada correctamente"),
                      backgroundColor: colorVioletaCorporativo, //
                    ),
                  );
                }
              },
              child: const Text("Actualizar"),
            ),
          ],
        );
      },
    );
  }

  // Tarjeta visual estética para listar los datos en modo lectura
  Widget _buildItemPerfil({required IconData icon, required String label, required String valor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: colorVioletaCorporativo.withOpacity(0.1),
            child: Icon(icon, color: colorVioletaCorporativo),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 2),
              Text(valor, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: colorVioletaCorporativo)),
      );
    }

    final String nombreCompleto = "${usuario?['nombre'] ?? ''} ${usuario?['apellido'] ?? ''}".trim();
    final String rolTexto = usuario?['rol'] == "ADMIN" ? "Administrador" : "Empleado";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Perfil", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar con la inicial del usuario
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: colorVioletaCorporativo, // Integrado al color dominante
                    child: Text(
                      usuario?['nombre']?.toString().isNotEmpty == true
                          ? usuario!['nombre'].toString().substring(0, 1).toUpperCase()
                          : "U",
                      style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    nombreCompleto.isEmpty ? "Usuario del Sistema" : nombreCompleto,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    rolTexto,
                    style: TextStyle(
                      color: colorVioletaCorporativo.withOpacity(0.8), 
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Tarjeta de Datos de Solo Lectura
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildItemPerfil(icon: Icons.person, label: "Nombre de Usuario", valor: "${usuario?['username']}"),
                    const Divider(),
                    _buildItemPerfil(icon: Icons.badge_outlined, label: "Nombre Real", valor: usuario?['nombre'] ?? "No asignado"),
                    const Divider(),
                    _buildItemPerfil(icon: Icons.badge_sharp, label: "Apellido", valor: usuario?['apellido'] ?? "No asignado"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 35),

            // Botón de Seguridad para cambiar la clave
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorVioletaCorporativo, //
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.lock_reset),
                label: const Text("CAMBIAR CONTRASEÑA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                onPressed: _mostrarDialogoCambiarPassword,
              ),
            ),
          ],
        ),
      ),
    );
  }
}