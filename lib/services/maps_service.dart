import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';

/// Centraliza la apertura de aplicaciones externas (Google Maps, WhatsApp y
/// marcador telefónico).
class MapsService {
  const MapsService();

  static const String _osmCopyrightUrl =
      'https://www.openstreetmap.org/copyright';

  /// Abre la ubicación exacta del punto de venta en Google Maps.
  Future<bool> abrirEnGoogleMaps(LatLng destino, {String? nombreLugar}) async {
    final String query =
        '${destino.latitude.toStringAsFixed(6)},'
        '${destino.longitude.toStringAsFixed(6)}';
    final Uri uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );
    return _abrir(uri);
  }

  /// Abre una conversación de WhatsApp con el número del comercio.
  Future<bool> contactarWhatsApp(
    String telefono, {
    String mensaje =
        '¡Hola! Vi su tienda en el directorio oficial de Nordland y quiero '
        'comprar sus productos.',
  }) async {
    final String soloDigitos = telefono.replaceAll(RegExp(r'[^0-9]'), '');
    final String numero = soloDigitos.startsWith('591')
        ? soloDigitos
        : '591$soloDigitos';
    final Uri uri = Uri.parse(
      'https://wa.me/$numero?text=${Uri.encodeComponent(mensaje)}',
    );
    return _abrir(uri);
  }

  Future<bool> llamar(String telefono) {
    final String soloDigitos = telefono.replaceAll(RegExp(r'[^0-9+]'), '');
    return _abrir(Uri.parse('tel:$soloDigitos'));
  }

  Future<bool> abrirLicenciaOpenStreetMap() =>
      _abrir(Uri.parse(_osmCopyrightUrl));

  Future<bool> _abrir(Uri uri) async {
    try {
      final bool abierto = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (abierto) return true;
    } on Object {
      // Si la app externa no está disponible se intenta con el navegador.
    }

    try {
      return await launchUrl(uri, mode: LaunchMode.platformDefault);
    } on Object {
      return false;
    }
  }
}

/// Acceso corto para mostrar un aviso cuando no se puede abrir un enlace.
void mostrarErrorEnlace(BuildContext context) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: NorlandColors.naranja,
        content: const Text(
          'No pudimos abrir la aplicación. Revisa tu teléfono e inténtalo de nuevo.',
        ),
      ),
    );
}
