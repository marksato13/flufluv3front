import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluflu/src/utils/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluflu/src/pages/lodging/services/list/lodging_services_list_controller.dart';

class LodgingServicesListPage extends StatefulWidget {
  const LodgingServicesListPage({Key? key}) : super(key: key);

  @override
  _LodgingServicesListPageState createState() => _LodgingServicesListPageState();
}

class _LodgingServicesListPageState extends State<LodgingServicesListPage> {
  final LodgingServicesListController _con = LodgingServicesListController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _con.init(context, refresh);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      appBar: AppBar(
        title: const Text('Lista de servicios '),
        leading: _menuIcon(),
      ),
      drawer:  _drawer(),  // No mostrar el drawer si es invitado

      body: _buildBody(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInfoCard(),
          const SizedBox(height: 20),
          _buildActionButtons(),
          const SizedBox(height: 20),
          _buildSubscriptionSection(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => _con.onTabSelected(1), // Añadir nuevo alojamiento
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Añadir Nuevo Alojamiento'),
        ),
        OutlinedButton(
          onPressed: () => _con.onTabSelected(2), // Ver lista de alojamientos
          child: const Text('Ver Lista de Alojamientos'),
        ),
      ],
    );
  }

  Widget _buildSubscriptionSection() {
    return Card(
      color: Colors.amber.shade100,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Date de alta gratis',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'El 45% de los arrendadores recibe su primera reserva en una semana.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _con.goToSelectPlan, // Navegar a selección de plan
              style: ElevatedButton.styleFrom(backgroundColor: MyColors.primaryColor),
              child: const Text('Empieza Ahora'),
            ),
            TextButton(
              onPressed: _con.continueRegistration,
              child: const Text('¿Ya habías empezado a registrarte?'),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildInfoCard() {
    return Card(
      color: Colors.blue.shade50,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Image.asset('assets/img/LOGO.png', width: 50, height: 50),
        title: const Text(
          '¿Eres arrendador? ¡Únete!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text(
          'Registra tu alojamiento y empieza a ganar dinero.',
        ),
        trailing: TextButton(
          onPressed: _con.goToHelp,
          child: const Text('Ayuda'),
        ),
      ),
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

  Widget _menucajita() {
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
            title: const Text('Editar perfil'),
            trailing: const Icon(Icons.edit_outlined),
          ),
          ListTile(
            title: const Text('Mis alojamientos'),
            trailing: const Icon(Icons.home_sharp),
          ),
          // Corrección del operador ternario
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
              Icons.add,
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
              Icons.my_library_add,
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
              Icons.payment,
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
              Icons.select_all,
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

  void refresh() {
    setState(() {});
  }
}
