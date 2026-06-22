import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mi_app/models/pedido.dart';
import 'package:mi_app/models/producto.dart';
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

  //3 crear un insumo

  // =========================
  // CREAR INSUMO
  // =========================
  Future<bool> crearInsumo({
    required String nombre,
    required String categoria,
    required int stock,
    required String ubicacion,
  }) async {
    //aca traemos el token
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

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
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
  // ELIMINAR INSUMO
  // =========================

  Future<bool> eliminarInsumo(int id) async {
    final headers = await _headers();

    final response = await http.delete(
      Uri.parse('$baseUrl/insumos/eliminar/$id/'),
      headers: headers,
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
      final headers = await _headers();

      final response = await http.post(
        Uri.parse('$baseUrl/usuarios/crear/'),
        headers: headers,

        body: jsonEncode({
          'username': username,
          'password': password,
          'rol': rol,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  //5
  Future<bool> crearProducto(Producto producto) async {
    final url = Uri.parse('$baseUrl/productos/crear/');
    //aca traemos el token
    final authService = AuthService();
    String? token = await authService.obtenerToken();
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(producto.toJson()),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      await authService.refreshToken();
      return false;
    }
  }

  //6
  Future<bool> crearPedido(Pedido pedido) async {
    final url = Uri.parse('$baseUrl/pedidos/crear/');
    //aca traemos el token
    final authService = AuthService();
    String? token = await authService.obtenerToken();

    print('esto estamos mandando a la base de datos ${pedido.toJson()}');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(pedido.toJson()),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      await authService.refreshToken();
      return false;
    }
  }

  Future<List<dynamic>> obtenerProductosLite() async {
    final url = Uri.parse("$baseUrl/productos/");
    //aca traemos el token
    final authService = AuthService();
    String? token = await authService.obtenerToken();

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Error al obtener productos: ${response.body}");
    }
  }
}
