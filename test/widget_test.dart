import 'package:flutter_test/flutter_test.dart';
import 'package:nordland_puntos_venta/models/punto_de_venta.dart';
import 'package:nordland_puntos_venta/services/puntos_venta_service.dart';

void main() {
  final PuntosVentaService servicio = PuntosVentaService.instance;

  group('Directorio de puntos de venta', () {
    test('contiene cinco puntos de venta simulados', () {
      expect(servicio.puntos, hasLength(5));
    });

    test('ordena los puntos por cercanía', () {
      final List<PuntoVentaCercano> cercanos = servicio.cercanos();
      for (int i = 1; i < cercanos.length; i++) {
        expect(
          cercanos[i - 1].distanciaKm,
          lessThanOrEqualTo(cercanos[i].distanciaKm),
        );
      }
    });

    test('filtra por ciudad', () {
      final List<PuntoVentaCercano> cochabamba = servicio.cercanos(
        ciudad: 'Cochabamba',
      );
      expect(cochabamba, hasLength(2));
      expect(
        cochabamba.every(
          (PuntoVentaCercano item) => item.punto.ciudad == 'Cochabamba',
        ),
        isTrue,
      );
    });

    test('calcula iniciales del nombre de la tienda', () {
      final PuntoDeVenta punto = servicio.porId('cb-001')!;
      expect(punto.iniciales, 'ME');
    });

    test('formatea distancias cortas y largas', () {
      expect(PuntosVentaService.formatearDistancia(0.75), '750 m');
      expect(PuntosVentaService.formatearDistancia(2.34), '2,3 km');
      expect(PuntosVentaService.formatearDistancia(231.4), '231 km');
    });
  });
}
