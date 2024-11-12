import 'package:flutter/material.dart';
import 'package:fluflu/src/utils/my_colors.dart'; // Asegúrate de que este sea el import correcto

class MySnackbar {
  static void show(BuildContext context, String text, Color backgroundColor) {
    // Verifica que el contexto no sea nulo
    if (context == null) return;

    // Oculta el teclado si está activo
    FocusScope.of(context).unfocus();

    // Remueve cualquier SnackBar anterior
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    // Muestra un nuevo SnackBar con el color y el estilo definidos
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white, // Color del texto para mayor contraste
            fontSize: 16,
            fontWeight: FontWeight.bold, // Estilo en negrita
          ),
        ),
        backgroundColor: backgroundColor, // Usa el color personalizado según el tipo de mensaje
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating, // Muestra el SnackBar de manera flotante
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Añade bordes redondeados
        ),
      ),
    );
  }

  // Función para mostrar flujo de éxito con color verde
  static void showSuccess(BuildContext context, String message) {
    show(context, message, MyColors.successColor);
  }

  // Función para mostrar error de acceso con color rojo
  static void showErrorAcceso(BuildContext context, String message) {
    show(context, message, MyColors.errorColor);
  }

  // Función para mostrar validación de campos con color amarillo
  static void showErrorValidacionCampos(BuildContext context, String message) {
    show(context, message, MyColors.validationColor);
  }

  // Función para notificación de problemas del servidor con color azul
  static void showProblemasServidor(BuildContext context, String message) {
    show(context, message, MyColors.serverErrorColor);
  }
}
