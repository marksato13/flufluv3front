import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluflu/src/api/environment.dart';
import 'package:fluflu/src/models/category.dart';
import 'package:fluflu/src/models/response_api.dart';
import 'package:fluflu/src/models/user.dart';
import 'package:fluflu/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CategoriesProvider {

  String _url = Environment.API_FLUFLU;
  String _api = '/api/categories';

  // Usamos 'late' para inicializarlas más tarde con null safety
  late BuildContext context;
  late User sessionUser;

  Future<void> init(BuildContext context, User sessionUser) async {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<List<Category>> getAll() async {
    try {
      Uri url = Uri.http(_url, '$_api/getAll');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        SharedPref().logout(context, sessionUser.id);
        return []; // Retornamos una lista vacía si la sesión expira
      }

      final data = json.decode(res.body); // Parseamos los datos de respuesta
      List<Category> categories = Category.fromJsonList(data); // Convertimos la respuesta en una lista de categorías
      return categories;
    } catch (e) {
      print('Error: $e');
      return []; // Retornamos una lista vacía en caso de error
    }
  }

  Future<ResponseApi> create(Category category) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(category);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.post(url, headers: headers, body: bodyParams);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        SharedPref().logout(context, sessionUser.id);
        return ResponseApi(success: false, message: 'Sesión expirada'); // Retornamos un objeto ResponseApi en lugar de null
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      return ResponseApi(success: false, message: 'Error: $e'); // Retornamos un ResponseApi con el error
    }
  }
}
