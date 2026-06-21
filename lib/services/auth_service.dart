import 'dart:convert';
import 'package:http/http.dart' as http;
//esto es para guardar el token
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //direccion de mi api

  final String baseUrl = 'http://10.0.2.2:8000';

  Future<dynamic> login(String username, String password) async {
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
      print('esto es lo que trae$data');

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('access_token', data['access']);

      return data;
    }

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
}
