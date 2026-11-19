import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

/// Abre el código QR estático de descarga de la aplicación móvil.
Future<void> mostrarQrNordland(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: NorlandColors.blanco,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NorlandRadius.lg),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        title: Row(
          children: <Widget>[
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: NorlandColors.verdeSuave,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.qr_code_2_rounded,
                size: 20,
                color: NorlandColors.verde,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Descarga la app',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: NorlandColors.blanco,
                borderRadius: BorderRadius.circular(NorlandRadius.md),
                border: Border.all(color: NorlandColors.borde),
              ),
              child: Image.asset(
                'assets/images/qr_nordland.png',
                width: 210,
                height: 210,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.medium,
                semanticLabel: 'Código QR de Nordland',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Escanea para descargar la app móvil',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: NorlandColors.texto,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Apunta la cámara de tu teléfono al código.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}
