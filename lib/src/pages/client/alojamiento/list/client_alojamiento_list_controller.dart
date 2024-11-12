import 'package:flutter/material.dart';
import 'package:fluflu/src/models/alojamiento.dart';
import 'package:fluflu/src/models/user.dart';
import 'package:fluflu/src/provider/alojamiento_provider.dart';
import 'package:fluflu/src/utils/shared_pref.dart';
import 'package:fluflu/src/pages/client/alojamiento/detail/client_alojamiento_detail_page.dart';  // Importa la página de detalles

class ClientAlojamientoListController {
  late BuildContext context;
  late Function refresh;
  List<Alojamiento> alojamientos = [];
  User? user;
  bool isGuest = false;  // Bandera para saber si es invitado
  bool isArrendador = false; // Nueva propiedad para saber si el usuario es Arrendador

  SharedPref _sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  AlojamientoProvider _alojamientoProvider = AlojamientoProvider();

  Future<void> init(BuildContext context, Function refresh, {bool isGuest = false}) async {
    this.context = context;
    this.refresh = refresh;
    this.isGuest = isGuest;  // Seteamos si el usuario es invitado
    if (!isGuest) {
      user = User.fromJson(await _sharedPref.read('user'));
      _alojamientoProvider.init(context, user!);

      // Verificar si el usuario tiene el rol de Arrendador
      isArrendador = user?.roles.any((role) => role.id == '2') ?? false;
    }
    print('Es invitado: $isGuest');
    await getAlojamientos();  // Llamada a obtener alojamientos
    refresh();
  }

  // Este es el método que estás preguntando
  Future<void> getAlojamientos() async {
    try {
      print('Iniciando la solicitud de alojamientos...');
      alojamientos = await _alojamientoProvider.getAll(isGuest: isGuest);
      print('Alojamientos obtenidos: ${alojamientos.length}');
      refresh();  // Actualizar el estado después de obtener los datos
    } catch (e) {
      print('Error al obtener alojamientos: $e');
    }
  }

  // Nueva función para redirigir a los detalles del alojamiento
  void goToAlojamientoDetail(Alojamiento alojamiento) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientAlojamientoDetailPage(alojamiento: alojamiento),
      ),
    );
  }

  void logout() {
    _sharedPref.logout(context, user!.id);
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void openDrawer() {
    if (key.currentState != null) {
      key.currentState!.openDrawer();
    }
  }

  void goToUpdatePage() {
    Navigator.pushNamed(context, 'client/update');
  }

  void goToAssignRole() {
    Navigator.pushNamed(context, 'client/update/roles');
  }


  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  void onTabSelected(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, 'client/estudiante/list');
        break;
      case 1:
        Navigator.pushNamed(context, '/map');
        break;
      case 2:
        Navigator.pushNamed(context, '/favorites');
        break;
      case 3:
        Navigator.pushNamed(context, '/messages');
        break;
      case 4:
        Navigator.pushNamed(context, '/roomies');
        break;
      default:
        Navigator.pushNamed(context, 'client/estudiante/list');
        break;
    }
  }
}
