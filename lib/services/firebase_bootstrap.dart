import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart'; // <-- Usamos las opciones generadas automáticamente

class FirebaseInitResult {
  const FirebaseInitResult._({
    required this.inicializado,
    this.mensaje,
    this.detalle,
  });

  const FirebaseInitResult.ok()
    : inicializado = true,
      mensaje = null,
      detalle = null;

  final bool inicializado;
  final String? mensaje;
  final String? detalle;
}

abstract final class FirebaseBootstrap {
  static Future<FirebaseInitResult> inicializar() async {
    // Si Firebase ya está inicializado, no hacemos nada más
    if (Firebase.apps.isNotEmpty) {
      return const FirebaseInitResult.ok();
    }

    try {
      // Inicializamos usando la configuración automática
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      return const FirebaseInitResult.ok();
      
    } on FirebaseException catch (error) {
      return FirebaseInitResult._(
        inicializado: false,
        mensaje:
            'No se pudo conectar con Firebase. Revisa la configuración del '
            'proyecto e inténtalo de nuevo.',
        detalle: error.message ?? error.code,
      );
    } catch (error) {
      return FirebaseInitResult._(
        inicializado: false,
        mensaje:
            'No se pudo iniciar Firebase. Verifica los archivos de '
            'configuración de Android, iOS o web.',
        detalle: error.toString(),
      );
    }
  }
}