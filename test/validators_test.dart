import 'package:flutter_test/flutter_test.dart';
import 'package:nordland_puntos_venta/utils/validators.dart';

void main() {
  group('Validaciones de acceso', () {
    test('acepta correos válidos y rechaza formatos incorrectos', () {
      expect(validarCorreo('cliente@nordland.bo'), isNull);
      expect(validarCorreo('correo-sin-arroba'), isNotNull);
      expect(validarCorreo(''), 'Ingresa tu correo electrónico.');
    });

    test('exige contraseñas de al menos seis caracteres', () {
      expect(validarContrasena('123456'), isNull);
      expect(
        validarContrasena('123'),
        'La contraseña debe tener al menos 6 caracteres.',
      );
      expect(validarContrasena(null), 'Ingresa tu contraseña.');
    });

    test('valida el nombre para el registro', () {
      expect(validarNombre('Ana'), isNull);
      expect(validarNombre(' '), 'Ingresa tu nombre.');
      expect(validarNombre('A'), 'El nombre es demasiado corto.');
    });
  });
}
