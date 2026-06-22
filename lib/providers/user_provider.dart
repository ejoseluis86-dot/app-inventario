import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
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
