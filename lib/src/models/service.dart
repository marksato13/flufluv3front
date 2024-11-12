class Service {
  String id;
  String nombre;
  String descripcion;  // Campo de descripción

  Service({
    required this.id,
    required this.nombre,
    required this.descripcion,  // Añadimos la descripción

  });

  // Método para deserializar una categoría desde JSON
  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json['id'].toString(),
    nombre: json['nombre'] ?? '',
    descripcion: json['descripcion'] ?? '',  // Parseamos la descripción

  );

  // Método para convertir una categoría a JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'descripcion': descripcion,  // Incluimos la descripción

  };
}
