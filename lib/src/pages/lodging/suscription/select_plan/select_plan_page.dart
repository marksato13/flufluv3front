import 'package:flutter/material.dart';
import 'select_plan_controller.dart';

class SelectPlanPage extends StatefulWidget {
  const SelectPlanPage({Key? key}) : super(key: key);

  @override
  _SelectPlanPageState createState() => _SelectPlanPageState();
}

class _SelectPlanPageState extends State<SelectPlanPage> {
  final SelectPlanPageController _con = SelectPlanPageController();

  @override
  void initState() {
    super.initState();
    _con.init(context, refresh); // No necesitamos pasar el userId aquí
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Plan de Suscripción'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPlanCard('1', 'Gratuito', 'Acceso básico', '\$0.00'),
            _buildPlanCard('2', 'Estándar', 'Funciones intermedias', '\$9.99'),
            _buildPlanCard('3', 'Premium', 'Acceso completo', '\$19.99'),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(String planId, String title, String description, String price) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(description),
            Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () => _con.createSubscription(planId),
              child: Text('Seleccionar $title'),
            ),
          ],
        ),
      ),
    );
  }
}
