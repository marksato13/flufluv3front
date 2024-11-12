import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluflu/src/api/environment.dart';
import 'package:fluflu/src/models/alojamiento.dart';
import 'package:fluflu/src/models/user.dart';
import 'package:http/http.dart' as http;

class AlojamientoProvider {
  String _url = Environment.API_FLUFLU;  // URL base de la API
  String _api = '/api/alojamientos';    // Ruta de los alojamientos

  late BuildContext context;
  late User sessionUser;

  Future<void> init(BuildContext context, User sessionUser) async {
    this.context = context;
    this.sessionUser = sessionUser;  // Inicializamos el usuario de la sesión
  }

  // Obtener todos los alojamientos (con posibilidad de obtener datos como invitado)
  // Obtener todos los alojamientos
  Future<List<Alojamiento>> getAll({bool isGuest = false}) async {
    try {
      print('Iniciando solicitud de alojamientos...');
      Uri url = Uri.http(_url, isGuest ? '$_api/getAllGuest' : '$_api/getAll');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        if (!isGuest) 'Authorization': sessionUser.sessionToken,  // Solo si no es invitado se usa token
      };
      final res = await http.get(url, headers: headers);

      print('Respuesta de la API: ${res.statusCode}');
      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body);
        print('Datos recibidos: $data');
        return data.map((json) => Alojamiento.fromJson(json)).toList();
      } else {
        print('Error al obtener alojamientos, código: ${res.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error al hacer la solicitud: $e');
      return [];
    }
  }


  // Obtener alojamientos por ID de usuario (dueño del alojamiento)
  Future<List<Alojamiento>> findByUserId(String idUser) async {
    try {
      Uri url = Uri.http(_url, '$_api/user/$idUser');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken,  // Token del usuario autenticado
      };

      final res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body);
        return data.map((json) => Alojamiento.fromJson(json)).toList();
      } else {
        print('Error al obtener alojamientos por usuario, código: ${res.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error al hacer la solicitud: $e');
      return [];
    }
  }

  // Crear un nuevo alojamiento
  Future<bool> createAlojamiento(Alojamiento alojamiento) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(alojamiento);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken,  // Token del usuario autenticado
      };

      final res = await http.post(url, headers: headers, body: bodyParams);
      if (res.statusCode == 200) {
        return true;
      } else {
        print('Error al crear el alojamiento, código: ${res.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error al crear el alojamiento: $e');
      return false;
    }
  }

  // Actualizar un alojamiento
  Future<bool> updateAlojamiento(Alojamiento alojamiento) async {
    try {
      Uri url = Uri.http(_url, '$_api/update/${alojamiento.id}');
      String bodyParams = json.encode(alojamiento);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken,  // Token del usuario autenticado
      };

      final res = await http.put(url, headers: headers, body: bodyParams);
      if (res.statusCode == 200) {
        return true;
      } else {
        print('Error al actualizar el alojamiento, código: ${res.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error al actualizar el alojamiento: $e');
      return false;
    }
  }

  // Eliminar un alojamiento por ID
  Future<bool> deleteAlojamiento(String idAlojamiento) async {
    try {
      Uri url = Uri.http(_url, '$_api/delete/$idAlojamiento');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken,  // Token del usuario autenticado
      };

      final res = await http.delete(url, headers: headers);
      if (res.statusCode == 200) {
        return true;
      } else {
        print('Error al eliminar el alojamiento, código: ${res.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error al eliminar el alojamiento: $e');
      return false;
    }
  }

}
