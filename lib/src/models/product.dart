import 'dart:convert';

/// Funciones para convertir JSON a Product y viceversa.
Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  String id;
  String name;
  String description;
  String image1;
  String image2;
  String image3;
  double price;
  int idCategory;
  int quantity;

  /// Constructor del modelo `Product`
  Product({
    this.id = '',
    this.name = '',
    this.description = '',
    this.image1 = '',
    this.image2 = '',
    this.image3 = '',
    this.price = 0.0,
    this.idCategory = 0,
    this.quantity = 0,
  });

  /// Método factory para crear un `Product` a partir de un JSON.
  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"] is int ? json["id"].toString() : json['id'] ?? '',
    name: json["name"] ?? '',
    description: json["description"] ?? '',
    image1: json["image1"] ?? '',
    image2: json["image2"] ?? '',
    image3: json["image3"] ?? '',
    price: json['price'] is String
        ? double.parse(json["price"])
        : isInteger(json["price"])
        ? json["price"].toDouble()
        : json['price'],
    idCategory: json["id_category"] is String
        ? int.parse(json["id_category"])
        : json["id_category"] ?? 0,
    quantity: json["quantity"] ?? 0,
  );

  /// Convierte el objeto `Product` a un mapa JSON.
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "image1": image1,
    "image2": image2,
    "image3": image3,
    "price": price,
    "id_category": idCategory,
    "quantity": quantity,
  };

  /// Convierte una lista dinámica de JSON en una lista de productos `Product`.
  static List<Product> fromJsonList(List<dynamic> jsonList) {
    if (jsonList.isEmpty) return [];
    return jsonList.map((item) => Product.fromJson(item)).toList();
  }

  /// Función auxiliar para verificar si un valor es entero.
  static bool isInteger(num value) => value is int || value == value.roundToDouble();
}
