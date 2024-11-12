import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:fluflu/src/api/environment.dart';
import 'package:fluflu/src/models/category.dart';
import 'package:fluflu/src/models/product.dart';
import 'package:fluflu/src/models/response_api.dart';
import 'package:fluflu/src/models/user.dart';
import 'package:fluflu/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ProductsProvider {
  String _url = Environment.API_FLUFLU;
  String _api = '/api/products';

  // Usamos 'late' para inicializarlas más tarde, compatible con null safety
  late BuildContext context;
  late User sessionUser;

  // Inicialización del contexto y el usuario de sesión
  Future<void> init(BuildContext context, User sessionUser) async {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<List<Product>> getByCategory(String idCategory) async {
    try {
      Uri url = Uri.http(_url, '$_api/findByCategory/$idCategory');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPref().logout(context, sessionUser.id);
        return []; // Retornamos una lista vacía si la sesión expira
      }

      final data = json.decode(res.body); // Parseamos la respuesta
      List<Product> products = Product.fromJsonList(data); // Nos aseguramos de obtener una lista de productos
      return products;
    }
    catch(e) {
      print('Error: $e');
      return []; // Retornamos una lista vacía en caso de error
    }
  }

  Future<List<Product>> getByCategoryAndProductName(String idCategory, String productName) async {
    try {
      Uri url = Uri.http(_url, '$_api/findByCategoryAndProductName/$idCategory/$productName');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPref().logout(context, sessionUser.id);
        return []; // Retornamos una lista vacía si la sesión expira
      }

      final data = json.decode(res.body); // Parseamos la respuesta
      List<Product> products = Product.fromJsonList(data); // Convertimos la respuesta en una lista de productos
      return products;
    }
    catch(e) {
      print('Error: $e');
      return []; // Retornamos una lista vacía en caso de error
    }
  }

  Future<Stream> create(Product product, List<File> images) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = sessionUser.sessionToken;

      for (int i = 0; i < images.length; i++) {
        request.files.add(http.MultipartFile(
            'image',
            http.ByteStream(images[i].openRead().cast()),
            await images[i].length(),
            filename: basename(images[i].path)
        ));
      }

      request.fields['product'] = json.encode(product); // Codificamos el producto como JSON
      final response = await request.send(); // Enviamos la petición
      return response.stream.transform(utf8.decoder); // Transformamos la respuesta en Stream
    }
    catch(e) {
      print('Error: $e');
      // Retornamos un stream vacío en caso de error, ya que no podemos retornar null
      return Stream.empty();
    }
  }
}
