import 'package:flutter/material.dart';
import 'package:mi_app/services/api_service.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final ApiService api = ApiService();
  
  bool loading = true;
  List<dynamic> todosLosUsuarios = [];

  // Controladores para el formulario de nuevo usuario
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final passwordController = TextEditingController();
  String rolSeleccionado = 'EMPLEADO';

  // 🔮 Color institucional violeta de tu Login y Home
  final Color colorVioletaCorporativo = const Color(0xFF6A1B9A);

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  @override
  void dispose() {
    usernameController.dispose();
    nombreController.dispose();
    apellidoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> cargarUsuarios() async {
    setState(() => loading = true);
    try {
      // Llamada a tu ApiService (mapeado para el endpoint de Django)
      final data = await api.obtenerUsuariosAdmin();
      setState(() {
        todosLosUsuarios = data;
        loading = false;
      });
    } catch (e) {
      print("ERROR CARGANDO USUARIOS: $e");
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al conectar con el servidor"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleToggleUsuario(int id, String username, bool estadoActual) async {
    final accion = estadoActual ? "desactivar" : "activar";
    
    // Confirmación visual rápida antes de impactar los históricos
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${accion.toUpperCase()} usuario"),
        content: Text("¿Estás seguro de que querés $accion al usuario '$username'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Confirmar", style: TextStyle(color: colorVioletaCorporativo))),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      final exito = await api.toggleUsuario(id);
      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Usuario $username modificado correctamente"),
            backgroundColor: colorVioletaCorporativo,
          ),
        );
        cargarUsuarios(); // Recargamos la lista limpia
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: No podés realizar esta acción"), backgroundColor: Colors.red),
      );
    }
  }
  // Diálogo para EDITAR usuario existente
    void _mostrarDialogoEditarUsuario(Map<String, dynamic> user) {
      final nombreController = TextEditingController(text: user['nombre'] ?? '');
      final apellidoController = TextEditingController(text: user['apellido'] ?? '');
      String rolActual = user['rol'] ?? 'EMPLEADO';

      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Editar Usuario"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nombreController, decoration: const InputDecoration(labelText: "Nombre")),
                  TextField(controller: apellidoController, decoration: const InputDecoration(labelText: "Apellido")),
                  const SizedBox(height: 15),
                  // En _mostrarDialogoEditarUsuario
                  DropdownButtonFormField<String>(
                    value: rolActual,
                    onChanged: (val) {
                      setDialogState(() { // <--- ESTE setDialogState es vital
                        rolActual = val!;
                      });
                    },
                    items: const [
                      DropdownMenuItem(value: 'EMPLEADO', child: Text('Empleado')),
                      DropdownMenuItem(value: 'ADMIN', child: Text('Administrador')),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
                ElevatedButton(
                  onPressed: () async {
                    await api.editarUsuarioAdmin(
                      idUsuario: user['id'],
                      nombre: nombreController.text,
                      apellido: apellidoController.text,
                      rol: rolActual,
                    );
                    if (mounted) {
                      Navigator.pop(context);
                      cargarUsuarios();
                    }
                  },
                  child: const Text("Guardar"),
                ),
              ],
            );
          }
        ),
      );
    }
  // Diálogo para crear un nuevo usuario/empleado
  void _mostrarDialogoCrearUsuario() {
    usernameController.clear();
    nombreController.clear();
    apellidoController.clear();
    passwordController.clear();
    rolSeleccionado = 'EMPLEADO';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder( // Permite refrescar el Dropdown dentro del diálogo
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Icon(Icons.person_add, color: colorVioletaCorporativo),
                  const SizedBox(width: 10),
                  const Text("Nuevo Usuario", style: TextStyle(fontSize: 20)),
                ],
              ),
              content: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(labelText: "Nombre de Usuario (Login)", prefixIcon: Icon(Icons.account_circle)),
                        validator: (value) => value == null || value.isEmpty ? "Ingresá el username" : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: nombreController,
                        decoration: const InputDecoration(labelText: "Nombre Real", prefixIcon: Icon(Icons.badge_outlined)),
                        validator: (value) => value == null || value.isEmpty ? "Ingresá el nombre" : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: apellidoController,
                        decoration: const InputDecoration(labelText: "Apellido", prefixIcon: Icon(Icons.badge_sharp)),
                        validator: (value) => value == null || value.isEmpty ? "Ingresá el apellido" : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: "Contraseña Inicial", prefixIcon: Icon(Icons.lock_outline)),
                        validator: (value) => value == null || value.length < 6 ? "Mínimo 6 caracteres" : null,
                      ),
                      const SizedBox(height: 15),
                      // Selector de Rol Estilizado
                      DropdownButtonFormField<String>(
                        value: rolSeleccionado,
                        decoration: const InputDecoration(labelText: "Rol en el Sistema", prefixIcon: Icon(Icons.admin_panel_settings)),
                        items: const [
                          DropdownMenuItem(value: 'EMPLEADO', child: Text('Empleado (Ventas/Fábrica)')),
                          DropdownMenuItem(value: 'ADMIN', child: Text('Administrador Total')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() => rolSeleccionado = value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: colorVioletaCorporativo, foregroundColor: Colors.white),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    // Implementación futura al后端 (POST):
                    // await api.crearUsuario(username: usernameController.text, ...);
                    
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: const Text("Usuario creado con éxito"), backgroundColor: colorVioletaCorporativo),
                      );
                      cargarUsuarios();
                    }
                  },
                  child: const Text("Registrar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Construye cada renglón de la lista de usuarios
  Widget _buildUsuarioCard(Map<String, dynamic> user) {
    final int id = user['id'] ?? 0;
    final String username = user['username'] ?? '';
    final String nombreCompleto = "${user['nombre'] ?? ''} ${user['apellido'] ?? ''}".trim();
    
    final bool activo = user['activo'] ?? true;
    //MOSTRAR ROL COMPLETO
    // 1. Obtenemos el código original
    final String codigoRol = user['rol'] ?? 'EMPL';

    // 2. Traducimos el código a la palabra legible
    String textoRol = "Desconocido";
    if (codigoRol == 'ADMIN') {
      textoRol = "Administrador";
    } else if (codigoRol == 'EMPL') {
      textoRol = "Empleado";
    } else {
      textoRol = codigoRol; // Por si viene con otro nombre
    }


    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
      title: Text("${user['nombre']} ${user['apellido']}"),
      subtitle: Text("Rol: $textoRol"), // 3. Mostramos la variable traducida
        trailing: Row(
          mainAxisSize: MainAxisSize.min, // Esto es clave para que los iconos no se desplacen
          children: [
            // BOTÓN DE EDICIÓN
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () => _mostrarDialogoEditarUsuario(user), // Llamamos a la función del diálogo
            ),
            // BOTÓN DE TOGGLE (ACTIVO/INACTIVO)
            IconButton(
              icon: Icon(
                user['activo'] ? Icons.toggle_on : Icons.toggle_off,
                color: user['activo'] ? Colors.green : Colors.grey,
              ),
              // Pasamos los 3 argumentos que la función espera:
              onPressed: () => _handleToggleUsuario(
                user['id'], 
                user['username'], 
                user['activo']
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Gestión de Usuarios")),
        body: Center(child: CircularProgressIndicator(color: colorVioletaCorporativo)),
      );
    }

    // Filtrado dinámico por pestañas utilizando el flag activo/inactivo (Soft delete seguro para históricos)
    final activos = todosLosUsuarios.where((u) => u['activo'] == true).toList();
    final inactivos = todosLosUsuarios.where((u) => u['activo'] == false).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Gestión de Usuarios", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: colorVioletaCorporativo,
            labelColor: colorVioletaCorporativo,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(child: Text("Activos (${activos.length})", style: const TextStyle(fontWeight: FontWeight.bold))),
              Tab(child: Text("Inactivos (${inactivos.length})", style: const TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pestaña Activos
            activos.isEmpty
                ? const Center(child: Text("No hay usuarios activos"))
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10, bottom: 80),
                    itemCount: activos.length,
                    itemBuilder: (context, index) => _buildUsuarioCard(activos[index]),
                  ),
            // Pestaña Inactivos
            inactivos.isEmpty
                ? const Center(child: Text("No hay usuarios inactivos"))
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10, bottom: 80),
                    itemCount: inactivos.length,
                    itemBuilder: (context, index) => _buildUsuarioCard(inactivos[index]),
                  ),
          ],
        ),
        // Botón Flotante para registrar personal de forma limpia
        floatingActionButton: FloatingActionButton(
          backgroundColor: colorVioletaCorporativo,
          foregroundColor: Colors.white,
          onPressed: _mostrarDialogoCrearUsuario,
          child: const Icon(Icons.person_add),
        ),
      ),
    );
  }
}