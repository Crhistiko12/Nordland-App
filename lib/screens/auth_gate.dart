import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:material_ui/material_ui.dart';

import '../services/auth_service.dart';
import '../services/firebase_bootstrap.dart';
import 'bienvenida_screen.dart';
import 'firebase_config_screen.dart';
import 'inicio_screen.dart';
import 'splash_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key, required this.firebaseInicial});

  final FirebaseInitResult firebaseInicial;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late FirebaseInitResult _firebase = widget.firebaseInicial;
  bool _reintentando = false;

  Future<void> _reintentarFirebase() async {
    if (_reintentando) return;
    setState(() => _reintentando = true);

    final FirebaseInitResult resultado = await FirebaseBootstrap.inicializar();
    if (!mounted) return;

    setState(() {
      _firebase = resultado;
      _reintentando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_firebase.inicializado) {
      return FirebaseConfigScreen(
        resultado: _firebase,
        reintentando: _reintentando,
        onReintentar: _reintentarFirebase,
      );
    }

    return StreamBuilder<User?>(
      stream: AuthService.instance.cambiosDeSesion,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        if (snapshot.data != null) {
          return const InicioScreen();
        }
        return const BienvenidaScreen();
      },
    );
  }
}
