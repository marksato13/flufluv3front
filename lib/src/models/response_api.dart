import 'dart:convert';

ResponseApi responseApiFromJson(String str) => ResponseApi.fromJson(json.decode(str));

String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

class ResponseApi {
  String message;
  String? error;  // Error puede ser nullable
  bool success;
  dynamic data;

  ResponseApi({
    required this.message,
    this.error,  // Nullable error
    required this.success,
    this.data,  // data ya es nullable
  });

  factory ResponseApi.fromJson(Map<String, dynamic> json) {
    return ResponseApi(
      message: json["message"] ?? '',
      error: json["error"],  // No es necesario el operador `?? ''` ya que es nullable
      success: json["success"] ?? false,
      data: json["data"],  // Dejar tal cual para que acepte cualquier tipo
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "error": error,
    "success": success,
    "data": data,
  };
}
