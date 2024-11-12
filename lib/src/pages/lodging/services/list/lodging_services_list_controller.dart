import 'package:flutter/material.dart';
import 'package:fluflu/src/utils/shared_pref.dart';
import 'package:fluflu/src/models/user.dart';
import 'package:fluflu/src/provider/subscription_provider.dart';

class LodgingServicesListController {
  late BuildContext context;
  late Function refresh;
  User? user;
  SharedPref _sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  // Instancia del provider de suscripciones
  final SubscriptionProvider _subscriptionProvider = SubscriptionProvider();

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    refresh();
  }

  // Función para abrir el menú lateral
  void openDrawer() {
    if (key.currentState != null) {
      key.currentState!.openDrawer();
    }
  }

  // Función para cerrar sesión
  void logout() {
    _sharedPref.logout(context, user!.id);
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  // Navegar a la página de roles
  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  // Navegar a la ayuda
  void goToHelp() {
    Navigator.pushNamed(context, '/help');
  }

  // Navegar a la selección de plan de suscripción
  void goToSelectPlan() {
    Navigator.pushNamed(context, '/select_plan');
  }

  // Continuar el registro en caso de que el usuario ya haya empezado
  void continueRegistration() {
    Navigator.pushNamed(context, '/continue_registration');
  }

  // Método para manejar la selección de las pestañas en el BottomNavigationBar
  void onTabSelected(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, 'arrendador/arrendador/list');
        break;
      case 1:
        Navigator.pushNamed(context, '/create_alojamiento');
        break;
      case 2:
        Navigator.pushNamed(context, '/list_my_accommodations');
        break;
      case 3:
        Navigator.pushNamed(context, '/payments');
        break;
      case 4:
        goToSelectPlan();
        break;
      default:
        Navigator.pushNamed(context, 'arrendador/arrendador/list');
        break;
    }
  }
}
