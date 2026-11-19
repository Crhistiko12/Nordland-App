import 'package:material_ui/material_ui.dart';

import '../services/firebase_bootstrap.dart';
import '../theme/app_theme.dart';
import '../widgets/nordland_logo.dart';
import '../widgets/norland_waves.dart';

class FirebaseConfigScreen extends StatelessWidget {
  const FirebaseConfigScreen({
    super.key,
    required this.resultado,
    required this.onReintentar,
    this.reintentando = false,
  });

  final FirebaseInitResult resultado;
  final VoidCallback onReintentar;
  final bool reintentando;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NorlandColors.blanco,
      body: Stack(
        children: <Widget>[
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 180,
            child: IgnorePointer(child: NorlandWaves()),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    children: <Widget>[
                      const NordlandLogo(
                        height: 64,
                        alignment: Alignment.center,
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: NorlandColors.blanco,
                          borderRadius: BorderRadius.circular(NorlandRadius.xl),
                          border: Border.all(color: NorlandColors.borde),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: NorlandColors.azulRey.withValues(
                                alpha: 0.08,
                              ),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 54,
                              height: 54,
                              decoration: const BoxDecoration(
                                color: NorlandColors.naranjaSuave,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.cloud_off_rounded,
                                color: NorlandColors.naranja,
                                size: 27,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Falta conectar Firebase',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              resultado.mensaje ??
                                  'La aplicación no pudo iniciar el servicio '
                                      'de autenticación.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: NorlandColors.textoSecundario,
                                  ),
                            ),
                            if (resultado.detalle != null) ...<Widget>[
                              const SizedBox(height: 14),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: NorlandColors.fondo,
                                  borderRadius: BorderRadius.circular(
                                    NorlandRadius.sm,
                                  ),
                                ),
                                child: SelectableText(
                                  resultado.detalle!,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: NorlandColors.textoSecundario,
                                      ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: reintentando ? null : onReintentar,
                                child: reintentando
                                    ? const SizedBox(
                                        width: 21,
                                        height: 21,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.3,
                                          color: NorlandColors.blanco,
                                        ),
                                      )
                                    : const Text('Reintentar'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Android: coloca google-services.json en android/app.\n'
                        'iOS: agrega GoogleService-Info.plist al Runner.\n'
                        'Web: usa las variables FIREBASE_* al compilar.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
