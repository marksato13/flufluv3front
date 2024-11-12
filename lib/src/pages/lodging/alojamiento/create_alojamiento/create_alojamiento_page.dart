import 'package:flutter/material.dart';

class CreateAlojamientoPage extends StatelessWidget {
  const CreateAlojamientoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('agrega tu alojamiento'),
      ),
      body: Center(
        child: const Text('Aquí puedes agregar nuevo alojamiento.'),
      ),
    );
  }
}
