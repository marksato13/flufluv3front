import 'package:flutter/material.dart';

class SelectPlanPage extends StatelessWidget {
  const SelectPlanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Plan de Suscripción'),
      ),
      body: Center(
        child: Text('Listado de Planes de Suscripción'),
      ),
    );
  }
}
