import 'package:flutter/widgets.dart' show Locale;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Ubicación aproximada del visitante de la tienda.
class UbicacionDetectada {
  const UbicacionDetectada({
    required this.latitud,
    required this.longitud,
    this.ciudad,
    this.pais,
  });

  final double latitud;
  final double longitud;
  final String? ciudad;
  final String? pais;

  /// Texto listo para mostrar: ciudad y país o, si no hay geocodificación,
  /// las coordenadas.
  String get descripcion {
    final List<String> partes = <String>[
      if (ciudad != null && ciudad!.trim().isNotEmpty) ciudad!.trim(),
      if (pais != null && pais!.trim().isNotEmpty) pais!.trim(),
    ];

    if (partes.isEmpty) {
      return '${latitud.toStringAsFixed(4)}, ${longitud.toStringAsFixed(4)}';
    }
    return partes.join(', ');
  }
}

abstract final class UbicacionService {
  /// Solicita permiso y devuelve la ubicación del dispositivo.
  ///
  /// Devuelve `null` si el permiso fue rechazado, el servicio está apagado
  /// o la plataforma no permite obtener la ubicación.
  static Future<UbicacionDetectada?> obtenerUbicacion() async {
    try {
      final bool servicioActivo = await Geolocator.isLocationServiceEnabled();
      if (!servicioActivo) return null;

      LocationPermission permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        return null;
      }

      final Position posicion = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 12),
        ),
      );

      String? ciudad;
      String? pais;
      try {
        final List<Placemark> lugares = await Geocoding(
          locale: const Locale('es'),
        ).placemarkFromCoordinates(posicion.latitude, posicion.longitude);
        if (lugares.isNotEmpty) {
          final Placemark lugar = lugares.first;
          ciudad = _primeroNoVacio(<String?>[
            lugar.locality,
            lugar.subAdministrativeArea,
            lugar.administrativeArea,
          ]);
          pais = _primeroNoVacio(<String?>[lugar.country]);
        }
      } catch (_) {
        // Si la geocodificación inversa falla se muestran las coordenadas.
      }

      return UbicacionDetectada(
        latitud: posicion.latitude,
        longitud: posicion.longitude,
        ciudad: ciudad,
        pais: pais,
      );
    } catch (_) {
      return null;
    }
  }

  static String? _primeroNoVacio(List<String?> valores) {
    for (final String? valor in valores) {
      if (valor != null && valor.trim().isNotEmpty) return valor.trim();
    }
    return null;
  }
}
