import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mi_app/models/insumo.dart';
import 'package:mi_app/models/pedido.dart';
import 'package:mi_app/models/producto.dart';
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
  Future<Insumo> crearInsumo({
    required String nombre,
    required String categoria,
    required int stock,
    required String ubicacion,
  }) async {
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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('esto me esta trajendo la api $data');
      return Insumo.fromJson(data);
    } else {
      await authService.refreshToken();
      throw Exception("Error al crear insumo: ${response.body}");
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

  //5
  Future<bool> crearProducto(Producto producto) async {
    final url = Uri.parse('$baseUrl/productos/crear/');
    //aca traemos el token
    final authService = AuthService();
    String? token = await authService.obtenerToken();
    print('esto estamos mandando a la base de datos ${producto.toJson()}');
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
