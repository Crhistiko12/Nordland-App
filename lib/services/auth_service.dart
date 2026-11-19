import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;

import '../config/firebase_config.dart';
import 'google_auth_web_stub.dart'
    if (dart.library.js_interop) 'google_auth_web.dart';

class AuthServiceException implements Exception {
  const AuthServiceException(this.mensaje, {this.codigo});

  final String mensaje;
  final String? codigo;

  @override
  String toString() => mensaje;
}

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  fb.FirebaseAuth get _auth => fb.FirebaseAuth.instance;

  Future<void>? _googleInit;
  bool _googleInicializado = false;

  fb.User? get usuarioActual => _auth.currentUser;

  Stream<fb.User?> get cambiosDeSesion => _auth.authStateChanges();

  Future<void> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: correo.trim(),
        password: contrasena,
      );
    } on fb.FirebaseAuthException catch (error) {
      throw _mapearError(error);
    }
  }

  Future<void> registrar({
    required String nombre,
    required String correo,
    required String contrasena,
  }) async {
    try {
      final fb.UserCredential credencial = await _auth
          .createUserWithEmailAndPassword(
            email: correo.trim(),
            password: contrasena,
          );

      final String nombreLimpio = nombre.trim();
      if (nombreLimpio.isNotEmpty) {
        await credencial.user?.updateDisplayName(nombreLimpio);
      }
    } on fb.FirebaseAuthException catch (error) {
      throw _mapearError(error);
    }
  }

  Future<bool> iniciarSesionConGoogle() async {
    try {
      if (kIsWeb) {
        await iniciarSesionConGoogleWeb();
        return _auth.currentUser != null;
      }

      await _inicializarGoogle();
      final gsi.GoogleSignInAccount cuenta = await gsi.GoogleSignIn.instance
          .authenticate();
      final String? idToken = cuenta.authentication.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw const AuthServiceException(
          'Google no devolvió un token válido. Revisa la configuración de '
          'OAuth de la app.',
        );
      }

      await _auth.signInWithCredential(
        fb.GoogleAuthProvider.credential(idToken: idToken),
      );
      return true;
    } on gsi.GoogleSignInException catch (error) {
      if (error.code == gsi.GoogleSignInExceptionCode.canceled) {
        return false;
      }
      if (error.code ==
              gsi.GoogleSignInExceptionCode.clientConfigurationError ||
          error.code ==
              gsi.GoogleSignInExceptionCode.providerConfigurationError) {
        throw const AuthServiceException(
          'Google Sign-In no está configurado correctamente. Revisa el ID de '
          'cliente y la huella SHA-1 del proyecto.',
        );
      }
      throw AuthServiceException(
        'No se pudo iniciar sesión con Google. Inténtalo de nuevo.',
        codigo: error.code.name,
      );
    } on fb.FirebaseAuthException catch (error) {
      if (error.code == 'popup-closed-by-user' ||
          error.code == 'cancelled-popup-request') {
        return false;
      }
      throw _mapearError(error);
    } on AuthServiceException {
      rethrow;
    } catch (error) {
      throw AuthServiceException(
        'No se pudo iniciar sesión con Google. $error',
      );
    }
  }

  Future<void> cerrarSesion() async {
    if (!kIsWeb && _googleInicializado) {
      try {
        await gsi.GoogleSignIn.instance.signOut();
      } catch (_) {}
    }
    await _auth.signOut();
  }

  Future<void> _inicializarGoogle() async {
    if (_googleInicializado) return;

    final String? serverClientId = FirebaseConfig.webClientId.trim().isEmpty
        ? null
        : FirebaseConfig.webClientId.trim();
    final String? clientId = FirebaseConfig.iosClientId.trim().isEmpty
        ? null
        : FirebaseConfig.iosClientId.trim();

    _googleInit ??= gsi.GoogleSignIn.instance.initialize(
      clientId: clientId,
      serverClientId: serverClientId,
    );

    await _googleInit;
    _googleInicializado = true;
  }

  AuthServiceException _mapearError(fb.FirebaseAuthException error) {
    final String mensaje = switch (error.code) {
      'invalid-email' => 'El correo electrónico no es válido.',
      'user-disabled' => 'Esta cuenta fue deshabilitada.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => 'Correo o contraseña incorrectos.',
      'email-already-in-use' =>
        'Ese correo ya tiene una cuenta. Prueba iniciando sesión.',
      'weak-password' => 'Usa una contraseña de al menos 6 caracteres.',
      'too-many-requests' =>
        'Demasiados intentos. Espera unos minutos e inténtalo de nuevo.',
      'network-request-failed' =>
        'No hay conexión. Revisa tu internet e inténtalo otra vez.',
      'operation-not-allowed' =>
        'Este método de acceso no está habilitado en Firebase.',
      'configuration-not-found' =>
        'Firebase Authentication no está configurado para esta app.',
      _ => 'Error de Firebase (${error.code}): ${error.message}',
    };

    return AuthServiceException(mensaje, codigo: error.code);
  }
}
