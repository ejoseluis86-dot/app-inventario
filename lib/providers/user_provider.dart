import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  int? id;
  String? username;
  String? nombre;
  String? apellido;
  String? rol;

  bool get isLogged => id != null;

  void clearUser() {
    id = null;
    username = null;
    nombre = null;
    apellido = null;
    rol = null;
    notifyListeners();
  }

  void setUser(
    int id,
    String username,
    String rol,
    {String? nombre,
    String? apellido,
  }) {
    this.id = id;
    this.username = username;
    this.rol = rol;
    this.nombre = nombre;
    this.apellido = apellido;

    notifyListeners();
  }
}