import 'package:flutter/material.dart';
import 'package:fluflu/src/utils/shared_pref.dart';
import 'package:fluflu/src/models/user.dart';

class AdminTodopoderosoListController {
  late BuildContext context;
  late Function refresh;
  User? user;
  SharedPref _sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key =new GlobalKey<ScaffoldState>();

  List<User> users = [];

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh =refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    refresh();

  }

  void logout() {
    // Cerrar la sesión del usuario
    _sharedPref.logout(context, user!.id);
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }


  void openDrawer() {
    // Verifica si el estado del Scaffold no es nulo antes de invocar openDrawer
    if (key.currentState != null) {
      key.currentState!.openDrawer();  // Usamos '!' para decirle a Dart que no es nulo
    }
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }




}
