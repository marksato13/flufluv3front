import 'package:flutter/material.dart';
import 'package:fluflu/src/models/user.dart';
import 'package:fluflu/src/utils/shared_pref.dart';

class RolesController {
  late BuildContext context;
  late Function refresh;
  User? user;
  SharedPref sharedPref = SharedPref();
  bool _isInitialized = false;

  Future<void> init(BuildContext context, Function refresh) async {
    if (_isInitialized) return; // Evita la inicialización múltiple
    _isInitialized = true;

    this.context = context;
    this.refresh = refresh;

    var userData = await sharedPref.read('user');
    if (userData != null) {
      user = User.fromJson(userData);
      print('Usuario cargado: ${user!.toJson()}');
      refresh();
    } else {
      print('No se encontró el usuario en SharedPreferences');
    }
  }

  void goToPage(String route) {
    if (context != null && route.isNotEmpty) {
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    } else {
      print('Contexto o ruta no están inicializados correctamente');
    }
  }
}
