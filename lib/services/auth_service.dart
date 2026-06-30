import 'dart:convert';
import 'package:http/http.dart' as http;
//esto es para guardar el token
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //direccion de mi api

  //final String baseUrl = 'http://10.0.2.2:8000';
  final String baseUrl = 'http://10.12.255.108:8000'; //conectar backend con wifi

  Future<dynamic> login(String username, String password) async {
    //hacemos la consulta a la API en el body mandamos usuario y contraseña
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('esto es lo que trae la Response : $data');

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('access_token', data['access']);
      await prefs.setString('refresh_token', data['refresh']); // 🔥 NUEVO

      return data;
    }
    //sino retornamos null
    return null;
  }

  Future<String?> obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('access_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('access_token');
  }

  Future<String?> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();

    final refresh = prefs.getString('refresh_token');

    if (refresh == null) return null;

    final response = await http.post(
      Uri.parse('$baseUrl/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refresh}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      await prefs.setString('access_token', data['access']);

      return data['access'];
    }

    // refresh expiró → logout
    await logout();
    return null;
  }
}
