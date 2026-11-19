import 'package:latlong2/latlong.dart';

import 'producto_nordland.dart';

/// Punto de venta oficial de Nordland.
class PuntoDeVenta {
  const PuntoDeVenta({
    required this.id,
    required this.nombre,
    required this.propietario,
    required this.telefono,
    required this.direccion,
    required this.ciudad,
    required this.zona,
    required this.latitud,
    required this.longitud,
    required this.calificacion,
    required this.totalResenas,
    required this.abierto,
    required this.horario,
    required this.productos,
  });

  final String id;
  final String nombre;
  final String propietario;
  final String telefono;
  final String direccion;
  final String ciudad;
  final String zona;
  final double latitud;
  final double longitud;
  final double calificacion;
  final int totalResenas;
  final bool abierto;
  final String horario;
  final List<ProductoNordland> productos;

  LatLng get ubicacion => LatLng(latitud, longitud);

  String get iniciales {
    final List<String> palabras = nombre
        .replaceAll(RegExp(r'[^a-zA-ZáéíóúÁÉÍÓÚñÑ ]'), '')
        .split(' ')
        .where((String palabra) => palabra.trim().isNotEmpty)
        .toList();

    if (palabras.isEmpty) return 'N';
    if (palabras.length == 1) {
      return palabras.first.substring(0, 1).toUpperCase();
    }
    return '${palabras.first[0]}${palabras.last[0]}'.toUpperCase();
  }
}

/// Punto de venta junto con su distancia respecto a una ubicación de referencia.
class PuntoVentaCercano {
  const PuntoVentaCercano({required this.punto, required this.distanciaKm});

  final PuntoDeVenta punto;
  final double distanciaKm;
}
