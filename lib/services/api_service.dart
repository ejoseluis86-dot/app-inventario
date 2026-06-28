import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mi_app/models/pedido.dart';
import 'package:mi_app/models/producto.dart';
import 'package:mi_app/services/auth_service.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8000/";
  final AuthService auth = AuthService();

  // =========================
  // HEADERS CON TOKEN
  // =========================
  Future<Map<String, String>> _headers() async {
    final token = await auth.obtenerToken();

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // =========================
  // REQUEST CENTRAL CON REFRESH
  // =========================
  Future<http.Response> _requestWithAuth(
    Future<http.Response> Function(Map<String, String>) request,
  ) async {
    final headers = await _headers();

    http.Response response = await request(headers);

    if (response.statusCode == 401) {
      print("🔁 Token vencido → refrescando...");

      await auth.refreshToken();

      final newHeaders = await _headers();

      response = await request(newHeaders);
    }

    return response;
  }

  // =========================
  // INSUMOS
  // =========================
  Future<List<dynamic>> obtenerInsumos() async {
    final response = await _requestWithAuth(
      (h) => http.get(Uri.parse('$baseUrl/insumos/'), headers: h),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Error al obtener insumos');
  }

  Future<bool> crearInsumo({
    required String nombre,
    required String categoria,
    required int stock,
    required String ubicacion,
  }) async {
    final response = await _requestWithAuth(
      (h) => http.post(
        Uri.parse('$baseUrl/insumos/insumo'),
        headers: h,
        body: jsonEncode({
          'nombre': nombre,
          'categoria': categoria,
          'stock': stock,
          'ubicacion': ubicacion,
        }),
      ),
    );

    return response.statusCode == 200;
  }

  Future<bool> actualizarInsumo({
    required int id,
    required String nombre,
    required String categoria,
    required int stock,
    required String ubicacion,
  }) async {
    final response = await _requestWithAuth(
      (h) => http.put(
        Uri.parse('$baseUrl/insumos/modificar/$id/'),
        headers: h,
        body: jsonEncode({
          'nombre': nombre,
          'categoria': categoria,
          'stock': stock,
          'ubicacion': ubicacion,
        }),
      ),
    );

    return response.statusCode == 200;
  }

  Future<bool> eliminarInsumo(int id) async {
    final response = await _requestWithAuth(
      (h) => http.delete(
        Uri.parse('$baseUrl/insumos/eliminar/$id/'),
        headers: h,
      ),
    );

    return response.statusCode == 200;
  }

  // =========================
  // USUARIOS
  // =========================
  Future<bool> crearUsuario({
    required String username,
    required String password,
    String rol = "EMPL",
  }) async {
    final response = await _requestWithAuth(
      (h) => http.post(
        Uri.parse('$baseUrl/usuarios/crear/'),
        headers: h,
        body: jsonEncode({
          'username': username,
          'password': password,
          'rol': rol,
        }),
      ),
    );

    return response.statusCode == 201;
  }

  Future<Map<String, dynamic>> obtenerMiPerfil() async {
    final response = await _requestWithAuth(
      (h) => http.get(
        Uri.parse('$baseUrl/usuarios/miPerfil/'),
        headers: h,
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Error al obtener perfil");
  }

  Future<bool> actualizarMiPerfil({
    required String nombre,
    required String apellido,
    required String username,
  }) async {
    final response = await _requestWithAuth(
      (h) => http.put(
        Uri.parse('$baseUrl/usuarios/modificarMiPerfil/'),
        headers: h,
        body: jsonEncode({
          "nombre": nombre,
          "apellido": apellido,
          "username": username,
        }),
      ),
    );

    return response.statusCode == 200;
  }

  // =========================
  // PRODUCTOS
  // =========================
  Future<Producto> obtenerProducto(int id) async {
    final response = await _requestWithAuth(
      (h) => http.get(
        Uri.parse('$baseUrl/productos/$id/'),
        headers: h,
      ),
    );

    if (response.statusCode == 200) {
      return Producto.fromJson(jsonDecode(response.body));
    }

    throw Exception("Error al obtener producto");
  }

  Future<List<dynamic>> obtenerProductosLite() async {
  final response = await _requestWithAuth(
    (h) => http.get(
      Uri.parse('$baseUrl/productos/'),
      headers: h,
    ),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  throw Exception("Error al obtener productos");
}

  Future<List<dynamic>> obtenerRecetaProducto(int idProducto) async {
    final response = await _requestWithAuth(
      (h) => http.get(
        Uri.parse('$baseUrl/productos/$idProducto/detalles-receta/'),
        headers: h,
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Error al obtener receta");
  }

  Future<bool> existeProducto(String nombre) async {
    final response = await _requestWithAuth(
      (h) => http.get(
        Uri.parse('$baseUrl/productos/existe/$nombre/'),
        headers: h,
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["existe"] == true;
    }

    return false;
  }


  Future<bool> crearProducto(Producto producto) async {
    final response = await _requestWithAuth(
      (h) => http.post(
        Uri.parse('$baseUrl/productos/crear/'),
        headers: h,
        body: jsonEncode(producto.toJson()),
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }

    if (response.statusCode == 400) {
      final body = jsonDecode(response.body);
      throw Exception(body["error"]);
    }

    throw Exception("Error al crear producto");
  }

  Future<bool> actualizarProducto(Producto producto) async {
    final response = await _requestWithAuth(
      (h) => http.put(
        Uri.parse('$baseUrl/productos/modificar/${producto.id}/'),
        headers: h,
        body: jsonEncode(producto.toJson()),
      ),
    );

    return response.statusCode == 200;
  }



  // =========================
  // PEDIDOS
  // =========================
  Future<List<dynamic>> obtenerPedidosLite() async {
    final response = await _requestWithAuth(
      (h) => http.get(
        Uri.parse('$baseUrl/pedidos/sin-terminar/'),
        headers: h,
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Error al obtener pedidos");
  }

  Future<bool> crearPedido(Pedido pedido) async {
    final response = await _requestWithAuth(
      (h) => http.post(
        Uri.parse('$baseUrl/pedidos/crear/'),
        headers: h,
        body: jsonEncode(pedido.toJson()),
      ),
    );

    return response.statusCode == 201 || response.statusCode == 200;
  }
}