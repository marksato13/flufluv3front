import 'package:fluflu/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluflu/src/pages/client/alojamiento/list/client_alojamiento_list_controller.dart';

class ClientAlojamientoListPage extends StatefulWidget {
  final bool isGuest;  // Añadimos este parámetro

  const ClientAlojamientoListPage({Key? key, this.isGuest = false}) : super(key: key);

  @override
  _ClientAlojamientoListPageState createState() => _ClientAlojamientoListPageState();
}

class _ClientAlojamientoListPageState extends State<ClientAlojamientoListPage> {
  final ClientAlojamientoListController _con = ClientAlojamientoListController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _con.init(context, refresh, isGuest: widget.isGuest);  // Iniciar con la bandera de invitado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      appBar: AppBar(
        title: const Text('Lista de Alojamientos'),
        leading: _menuIcon(),
      ),
      drawer: widget.isGuest ? null : _drawer(),  // No mostrar el drawer si es invitado
      body: _buildAlojamientoList(),
      bottomNavigationBar: widget.isGuest ? null : _bottomNavigationBar(),  // No mostrar la barra de navegación si es invitado
    );
  }

  Widget _menuIcon() {
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: const EdgeInsets.only(left: 15),
        alignment: Alignment.centerLeft,
        child: Image.asset('assets/img/LOGO.png', width: 50, height: 50),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: MyColors.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_con.user?.name ?? ''} ${_con.user?.lastname ?? ''}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                Text(
                  _con.user?.email ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                ),
                Text(
                  _con.user?.phone ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                ),
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(top: 10),
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/img/no-image.png'),
                    image: _con.user?.image != null && _con.user!.image.isNotEmpty
                        ? NetworkImage(_con.user!.image) as ImageProvider
                        : const AssetImage('assets/img/no-image.png'),
                    fit: BoxFit.contain,
                    fadeInDuration: const Duration(milliseconds: 50),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: _con.goToUpdatePage,
            title: const Text('Editar perfil'),
            trailing: const Icon(Icons.edit_outlined),
          ),
          // Mostrar este ListTile solo si el usuario no es Arrendador
          if (!_con.isArrendador)
            ListTile(
              onTap: _con.goToAssignRole,
              title: const Text('Cambiar a modo Arrendador'),
              trailing: const Icon(Icons.edit_outlined),
            ),
          /*
          ListTile(
            title: const Text('Mis alojamientos'),
            trailing: const Icon(Icons.home_sharp),
          ),
          */

          if (_con.user != null && (_con.user!.roles?.length ?? 0) > 1)
            ListTile(
              onTap: _con.goToRoles,
              title: const Text('Seleccionar rol'),
              trailing: const Icon(Icons.person_2_outlined),
            ),
          ListTile(
            onTap: _con.logout,
            title: const Text('Cerrar sesión'),
            trailing: const Icon(Icons.power_settings_new),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: _selectedIndex == 0 ? MyColors.primaryColor : Colors.grey,
            ),
            onPressed: () {
              _con.onTabSelected(0);
              setState(() {
                _selectedIndex = 0;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.location_on,
              color: _selectedIndex == 1 ? MyColors.primaryColor : Colors.grey,
            ),
            onPressed: () {
              _con.onTabSelected(1);
              setState(() {
                _selectedIndex = 1;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: _selectedIndex == 2 ? MyColors.primaryColor : Colors.grey,
            ),
            onPressed: () {
              _con.onTabSelected(2);
              setState(() {
                _selectedIndex = 2;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.message,
              color: _selectedIndex == 3 ? MyColors.primaryColor : Colors.grey,
            ),
            onPressed: () {
              _con.onTabSelected(3);
              setState(() {
                _selectedIndex = 3;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.people_alt,
              color: _selectedIndex == 4 ? MyColors.primaryColor : Colors.grey,
            ),
            onPressed: () {
              _con.onTabSelected(4);
              setState(() {
                _selectedIndex = 4;
              });
            },
          ),
        ],
      ),
    );
  }

  // Construimos la lista de alojamientos, limitando algunos detalles si es invitado
  Widget _buildAlojamientoList() {
    if (_con.alojamientos.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _con.alojamientos.length,
      itemBuilder: (context, index) {
        final alojamiento = _con.alojamientos[index];
        return Card(
          margin: const EdgeInsets.all(15.0),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen de alojamiento con bordes redondeados
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                child: alojamiento.image1.isNotEmpty
                    ? Image.network(
                  alojamiento.image1,
                  height: 200.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/img/no-image.png',
                  height: 200.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título y precio en fila
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            alojamiento.nombre,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          'S/ ${alojamiento.precio}',
                          style: TextStyle(
                            fontSize: 20,
                            color: MyColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Dirección
                    Text(
                      alojamiento.direccion,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Descripción
                    Text(
                      alojamiento.descripcion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Iconos con detalles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _iconInfo(Icons.straighten, '6×7 mtrs'),
                        _iconInfo(Icons.bathtub_outlined, '1 baño'),
                        _iconInfo(Icons.king_bed_outlined, 'Amoblado'),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Botón "Ver más"
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // Comprobar si el usuario es invitado
                          if (_con.isGuest) {
                            // Mostrar notificación si es invitado
                            _showLoginPrompt();
                          } else {
                            // Si no es invitado, redirige a los detalles
                            _con.goToAlojamientoDetail(alojamiento);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                          backgroundColor: MyColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text('Ver más'),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget para mostrar un ícono y texto en línea
  Widget _iconInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: MyColors.primaryColor, size: 20),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }


  void _showLoginPrompt() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            Positioned(
              top: 60,
              left: 30,
              right: 30,
              child: Material(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Por favor, inicia sesión o regístrate para ver más detalles.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, 'login');
                        },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10),
                          backgroundColor: Colors.blue,
                        ),
                        child: Icon(
                          Icons.login,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }






  void refresh() {
    setState(() {});
  }
}
