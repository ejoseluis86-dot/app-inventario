import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mi_app/services/auth_service.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8000/";

  Future<List<dynamic>> obtenerInsumos() async {
    //aca traemos el token
    final authService = AuthService();

    String? token = await authService.obtenerToken();
    //esto otiene el token
    print('esto tiene el token : $token');
    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/insumos/'),
        headers: {'Authorization': 'Bearer $token[]'},
      );
      if (response.statusCode == 200) {
        //aca esta retornando los insumos
        return jsonDecode(response.body);
      }
    } else {
      await authService.refreshToken();
    }

    throw Exception('Error al obtener Insumos');
  }

  //2 modificar stock por id y stock falta probar
  Future<bool> modificarStock(int idInsumo, int stock) async {
    try {
      //aca traemos el token
      final authService = AuthService();
      String? token = await authService.obtenerToken();

      final response = await http.put(
        Uri.parse('$baseUrl/insumos/modificar/$idInsumo/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'stock': stock}),
      );

      if (response.statusCode == 200) {
        print('Stock actualizado');
        print(response.body);
        return true;
      } else {
        await authService.refreshToken();
        print('Error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Excepción: $e');
      return false;
    }
  }

  //3 crear un insumo
  Future<bool> crearInsumo({
    required String nombre,
    required String categoria,
    required int stock,
    required String ubicacion,
  }) async {
    try {
      //aca traemos el token
      final authService = AuthService();
      String? token = await authService.obtenerToken();

      final response = await http.post(
        Uri.parse('$baseUrl/insumos/insumo'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nombre': nombre,
          'categoria': categoria,
          'stock': stock,
          'ubicacion': ubicacion,
        }),
      );

      if (response.statusCode == 201) {
        print('Insumo creado correctamente');
        print(response.body);
        return true;
      }
      await authService.refreshToken();
      print('Error: ${response.body}');
      return false;
    } catch (e) {
      print('Excepción: $e');
      return false;
    }
  }

  //4 creae usuario
  Future<bool> crearUsuario({
    required String username,
    required String password,
    String rol = "EMPL",
  }) async {
    //aca traemos el token
    final authService = AuthService();
    String? token = await authService.obtenerToken();
    var variable = jsonEncode({
      'username': username,
      'password': password,
      'rol': rol,
    });
    print('esto se esta mandando en el body $variable');

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
      print("Usuario creado");
      return true;
    } else {
      await authService.refreshToken();
      print(response.body);
      return false;
    }
  }
}
