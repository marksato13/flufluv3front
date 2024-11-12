import 'dart:convert';

/// Funciones para convertir JSON a Category y viceversa.
Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  String id;
  String name;
  String description;

  /// Constructor de la clase `Category`.
  Category({
    this.id = '',
    this.name = '',
    this.description = '',
  });

  /// Método factory para crear un objeto `Category` a partir de un mapa JSON.
  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"] is int ? json["id"].toString() : json["id"] ?? '',
    name: json["name"] ?? '',
    description: json["description"] ?? '',
  );

  /// Método para convertir un objeto `Category` en un mapa JSON.
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };

  /// Convierte una lista dinámica de JSON en una lista de `Category`.
  static List<Category> fromJsonList(List<dynamic> jsonList) {
    if (jsonList.isEmpty) return [];
    return jsonList.map((item) => Category.fromJson(item)).toList();
  }
}
