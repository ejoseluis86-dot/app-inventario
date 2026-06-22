import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mi_app/services/auth_service.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8000/";

  Future<Map<String, String>> _headers() async {
    final auth = AuthService();
    String? token = await auth.obtenerToken();

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // =========================
  // INSUMOS - LISTAR
  // =========================
  Future<List<dynamic>> obtenerInsumos() async {
    final headers = await _headers();

    final response = await http.get(
      Uri.parse('$baseUrl/insumos/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Error al obtener insumos');
  }

  // =========================
  // CREAR INSUMO
  // =========================
  Future<bool> crearInsumo({
    required String nombre,
    required String categoria,
    required int stock,
    required String ubicacion,
  }) async {
    final headers = await _headers();

    final response = await http.post(
      Uri.parse('$baseUrl/insumos/insumo'),
      headers: headers,
      body: jsonEncode({
        'nombre': nombre,
        'categoria': categoria,
        'stock': stock,
        'ubicacion': ubicacion,
      }),
    );

    return response.statusCode == 201;
  }

  // =========================
  // ACTUALIZAR INSUMO (FULL EDIT)
  // =========================
  Future<bool> actualizarInsumo({
    required int id,
    required String nombre,
    required String categoria,
    required int stock,
    required String ubicacion,
  }) async {
    final headers = await _headers();

    final response = await http.put(
      Uri.parse('$baseUrl/insumos/modificar/$id/'),
      headers: headers,
      body: jsonEncode({
        'nombre': nombre,
        'categoria': categoria,
        'stock': stock,
        'ubicacion': ubicacion,
      }),
    );

    return response.statusCode == 200;
  }

  // =========================
  // STOCK RÁPIDO (opcional)
  // =========================
  Future<bool> modificarStock(int idInsumo, int stock) async {
    final headers = await _headers();

    final response = await http.put(
      Uri.parse('$baseUrl/insumos/modificar/$idInsumo/'),
      headers: headers,
      body: jsonEncode({'stock': stock}),
    );

    return response.statusCode == 200;
  }

  
  // =========================
  // CREAR USUARIO 
  // =========================
  Future<bool> crearUsuario({
    required String username,
    required String password,
    String rol = "EMPL",
  }) async {
    try {
      final authService = AuthService();
      String? token = await authService.obtenerToken();

      final response = await http.post(
        Uri.parse('$baseUrl/usuarios/crear/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
          'rol': rol,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      }

      print(response.body);
      return false;
    } catch (e) {
      print("Error crear usuario: $e");
      return false;
    }
  }
}