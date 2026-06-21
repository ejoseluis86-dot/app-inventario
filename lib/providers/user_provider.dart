import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  int? id;
  String? username;
  String? rol;

  bool get isLogged => id != null;

  void clearUser() {
    id = null;
    username = null;
    rol = null;

    notifyListeners();
  }

  void setUser(int id, String username, String rol) {
    this.id = id;
    this.username = username;
    this.rol = rol;
    notifyListeners();
  }
}
