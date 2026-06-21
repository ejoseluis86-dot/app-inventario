import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mi_app/services/auth_service.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8000/";

  Future<List<dynamic>> obtenerInsumos() async {
    //aca traemos el token
    final authService = AuthService();

    String? token = await authService.obtenerToken();

    final response = await http.get(
      Uri.parse('$baseUrl/insumos/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      //aca esta retornando los insumos
      return jsonDecode(response.body);
    }

    throw Exception('Error al obtener Insumos');
  }
}
