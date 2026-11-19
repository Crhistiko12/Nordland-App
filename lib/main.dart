import 'package:cupertino_ui/cupertino_ui.dart'
    show GlobalCupertinoLocalizations;
import 'package:flutter_localizations/flutter_localizations.dart'
    hide GlobalCupertinoLocalizations, GlobalMaterialLocalizations;
import 'package:material_ui/material_ui.dart';

import 'screens/auth_gate.dart';
import 'services/cart_service.dart';
import 'services/firebase_bootstrap.dart';
import 'theme/app_theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseInitResult firebase = await FirebaseBootstrap.inicializar();

  runApp(NordlandApp(firebase: firebase));
}

class NordlandApp extends StatelessWidget {
  const NordlandApp({super.key, required this.firebase});

  final FirebaseInitResult firebase;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartService>(
      create: (_) => CartService(),
      child: MaterialApp(
        title: 'Nordland · Nutrición que te mueve',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        themeMode: ThemeMode.light,
        locale: const Locale('es', 'BO'),
        supportedLocales: const <Locale>[Locale('es', 'BO'), Locale('es')],
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: AuthGate(firebaseInicial: firebase),
      ),
    );
  }
}
