import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

import '../models/producto_nordland.dart';
import '../models/punto_de_venta.dart';
import '../theme/app_theme.dart';

/// Fuente de datos simulada del directorio de puntos de venta.
///
/// En una siguiente iteración este servicio puede reemplazarse por una API
/// sin modificar las pantallas, ya que expone únicamente modelos del dominio.
class PuntosVentaService {
  PuntosVentaService._();

  static final PuntosVentaService instance = PuntosVentaService._();

  /// Ubicación referencial usada para calcular distancias en la demo
  /// (centro de Cochabamba).
  static const LatLng ubicacionReferencia = LatLng(-17.3895, -66.1568);

  static const Distance _distance = Distance();

  static const ProductoNordland _natural = ProductoNordland(
    id: 'natural-900',
    nombre: 'Leche de Soya Natural',
    presentacion: 'Sachet · 900 ml',
    icono: Icons.eco_rounded,
    color: NorlandColors.verde,
  );

  static const ProductoNordland _natural2l = ProductoNordland(
    id: 'natural-2l',
    nombre: 'Leche de Soya Natural',
    presentacion: 'PET · 2 litros',
    icono: Icons.eco_rounded,
    color: NorlandColors.verde,
  );

  static const ProductoNordland _durazno = ProductoNordland(
    id: 'durazno-900',
    nombre: 'Leche de Soya Durazno',
    presentacion: 'Sachet · 900 ml',
    icono: Icons.local_drink_rounded,
    color: NorlandColors.naranja,
  );

  static const ProductoNordland _frutilla = ProductoNordland(
    id: 'frutilla-900',
    nombre: 'Leche de Soya Frutilla',
    presentacion: 'Sachet · 900 ml',
    icono: Icons.local_drink_rounded,
    color: NorlandColors.celeste,
  );

  static const ProductoNordland _mango = ProductoNordland(
    id: 'mango-900',
    nombre: 'Leche de Soya Mango',
    presentacion: 'Sachet · 900 ml',
    icono: Icons.local_drink_rounded,
    color: NorlandColors.amarillo,
  );

  static const ProductoNordland _mora = ProductoNordland(
    id: 'mora-900',
    nombre: 'Leche de Soya Mora',
    presentacion: 'Sachet · 900 ml',
    icono: Icons.local_drink_rounded,
    color: NorlandColors.azulRey,
  );

  static const ProductoNordland _limon = ProductoNordland(
    id: 'limon-900',
    nombre: 'Leche de Soya Limón',
    presentacion: 'Sachet · 900 ml',
    icono: Icons.local_drink_rounded,
    color: NorlandColors.verde,
  );

  static const ProductoNordland _heladoPomo = ProductoNordland(
    id: 'helado-pomo',
    nombre: 'Helado de Soya',
    presentacion: 'Pomo · 1 litro',
    icono: Icons.icecream_rounded,
    color: NorlandColors.celeste,
  );

  static const ProductoNordland _heladoGalon = ProductoNordland(
    id: 'helado-galón',
    nombre: 'Helado de Soya',
    presentacion: 'Galón · 3.75 litros',
    icono: Icons.icecream_rounded,
    color: NorlandColors.amarillo,
  );

  static const ProductoNordland _heladoVasito = ProductoNordland(
    id: 'helado-vasito',
    nombre: 'Helado de Soya',
    presentacion: 'Vasito · 90 ml',
    icono: Icons.icecream_rounded,
    color: NorlandColors.naranja,
  );

  static const ProductoNordland _agua = ProductoNordland(
    id: 'agua-20l',
    nombre: 'Agua Purificada',
    presentacion: 'Botellón · 20 litros',
    icono: Icons.water_drop_rounded,
    color: NorlandColors.celeste,
  );

  final List<PuntoDeVenta> _puntos = const <PuntoDeVenta>[
    PuntoDeVenta(
      id: 'cb-001',
      nombre: 'Minimarket Doña Elvira',
      propietario: 'Elvira Quispe',
      telefono: '+591 71234567',
      direccion: 'Av. Aroma esq. Tarapacá, La Cancha',
      ciudad: 'Cochabamba',
      zona: 'La Cancha',
      latitud: -17.3938,
      longitud: -66.1455,
      calificacion: 4.8,
      totalResenas: 128,
      abierto: true,
      horario: 'Lun a Sáb · 07:00 – 20:00',
      productos: <ProductoNordland>[_natural, _durazno, _frutilla, _heladoPomo],
    ),
    PuntoDeVenta(
      id: 'cb-002',
      nombre: 'Tienda Natural Vida',
      propietario: 'Ramiro Choque',
      telefono: '+591 72345678',
      direccion: 'Av. América Oeste #1250, Cala Cala',
      ciudad: 'Cochabamba',
      zona: 'Cala Cala',
      latitud: -17.3745,
      longitud: -66.1620,
      calificacion: 4.6,
      totalResenas: 74,
      abierto: true,
      horario: 'Lun a Dom · 08:00 – 21:00',
      productos: <ProductoNordland>[_natural2l, _mango, _mora, _agua],
    ),
    PuntoDeVenta(
      id: 'lp-001',
      nombre: 'Minimarket El Sol',
      propietario: 'María Fernández',
      telefono: '+591 70123456',
      direccion: 'Av. 6 de Agosto #2170, Sopocachi',
      ciudad: 'La Paz',
      zona: 'Sopocachi',
      latitud: -16.5090,
      longitud: -68.1260,
      calificacion: 4.7,
      totalResenas: 96,
      abierto: true,
      horario: 'Lun a Sáb · 08:30 – 20:30',
      productos: <ProductoNordland>[_natural, _durazno, _frutilla, _limon],
    ),
    PuntoDeVenta(
      id: 'lp-002',
      nombre: 'Tienda La Paz Verde',
      propietario: 'Javier Mamani',
      telefono: '+591 73456789',
      direccion: 'Av. Saavedra #1890, Miraflores',
      ciudad: 'La Paz',
      zona: 'Miraflores',
      latitud: -16.5008,
      longitud: -68.1206,
      calificacion: 4.5,
      totalResenas: 51,
      abierto: false,
      horario: 'Lun a Vie · 09:00 – 19:00',
      productos: <ProductoNordland>[_natural2l, _mango, _heladoVasito],
    ),
    PuntoDeVenta(
      id: 'sc-001',
      nombre: 'Comercial Los Pozos',
      propietario: 'Ana Rojas',
      telefono: '+591 67890123',
      direccion: 'Av. Cañoto #345, Los Pozos',
      ciudad: 'Santa Cruz',
      zona: 'Los Pozos',
      latitud: -17.7821,
      longitud: -63.1818,
      calificacion: 4.9,
      totalResenas: 203,
      abierto: true,
      horario: 'Lun a Sáb · 07:30 – 21:00',
      productos: <ProductoNordland>[_natural, _durazno, _heladoGalon, _agua],
    ),
  ];

  List<PuntoDeVenta> get puntos => List<PuntoDeVenta>.unmodifiable(_puntos);

  List<String> get ciudades => const <String>[
    'Todas',
    'Cochabamba',
    'La Paz',
    'Santa Cruz',
  ];

  /// Devuelve los puntos de venta filtrados por ciudad y ordenados por
  /// cercanía a la ubicación referencial.
  List<PuntoVentaCercano> cercanos({String ciudad = 'Todas'}) {
    final Iterable<PuntoDeVenta> filtrados = ciudad == 'Todas'
        ? _puntos
        : _puntos.where((PuntoDeVenta punto) => punto.ciudad == ciudad);

    final List<PuntoVentaCercano> resultado = filtrados
        .map(
          (PuntoDeVenta punto) =>
              PuntoVentaCercano(punto: punto, distanciaKm: distanciaKm(punto)),
        )
        .toList();

    resultado.sort(
      (PuntoVentaCercano a, PuntoVentaCercano b) =>
          a.distanciaKm.compareTo(b.distanciaKm),
    );
    return resultado;
  }

  PuntoDeVenta? porId(String id) {
    for (final PuntoDeVenta punto in _puntos) {
      if (punto.id == id) return punto;
    }
    return null;
  }

  double distanciaKm(PuntoDeVenta punto) =>
      _distance.as(LengthUnit.Kilometer, ubicacionReferencia, punto.ubicacion);

  static String formatearDistancia(double km) {
    if (km < 1) {
      return '${(km * 1000).round()} m';
    }
    if (km < 10) {
      return '${km.toStringAsFixed(1).replaceAll('.', ',')} km';
    }
    return '${km.round()} km';
  }
}
