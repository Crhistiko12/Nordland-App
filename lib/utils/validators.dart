String? validarCorreo(String? valor) {
  final String correo = valor?.trim() ?? '';
  if (correo.isEmpty) return 'Ingresa tu correo electrónico.';

  final RegExp patron = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
  if (!patron.hasMatch(correo)) return 'Ingresa un correo válido.';
  return null;
}

String? validarContrasena(String? valor) {
  final String contrasena = valor ?? '';
  if (contrasena.isEmpty) return 'Ingresa tu contraseña.';
  if (contrasena.length < 6) {
    return 'La contraseña debe tener al menos 6 caracteres.';
  }
  return null;
}

String? validarNombre(String? valor) {
  final String nombre = valor?.trim() ?? '';
  if (nombre.isEmpty) return 'Ingresa tu nombre.';
  if (nombre.length < 2) return 'El nombre es demasiado corto.';
  return null;
}
