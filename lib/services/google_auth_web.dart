import 'package:firebase_auth/firebase_auth.dart' as fb;

Future<void> iniciarSesionConGoogleWeb() async {
  try {
    final fb.GoogleAuthProvider googleProvider = fb.GoogleAuthProvider();
    // Forzar a que el usuario elija la cuenta
    googleProvider.setCustomParameters({'prompt': 'select_account'});

    await fb.FirebaseAuth.instance.signInWithPopup(googleProvider);
  } catch (e) {
    // ignore: avoid_print
    print("Error en login web: $e");
    rethrow;
  }
}
