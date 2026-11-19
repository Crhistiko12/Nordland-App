import 'package:flutter_test/flutter_test.dart';
import 'package:nordland_puntos_venta/models/producto.dart';
import 'package:nordland_puntos_venta/services/catalogo_service.dart';
import 'package:nordland_puntos_venta/utils/formato_moneda.dart';

void main() {
  group('Catálogo Nordland', () {
    test('incluye 17 productos y las cuatro categorías', () {
      expect(CatalogoService.categorias.length, 4);
      expect(CatalogoService.productos.length, 17);

      for (final CategoriaProducto categoria in CatalogoService.categorias) {
        expect(
          CatalogoService.productos
              .where((Producto producto) => producto.categoria == categoria)
              .length,
          greaterThanOrEqualTo(1),
        );
      }

      for (final Producto producto in CatalogoService.productos) {
        expect(producto.imagen, isNotNull);
        expect(producto.imagen!.startsWith('assets/images/PRODUCTOS/'), isTrue);
      }
    });

    test('filtra por categoría', () {
      final List<Producto> yogurts = CatalogoService.filtrar(
        categoria: CategoriaProducto.yogurts,
      );

      expect(yogurts.length, 9);
      expect(
        yogurts.every(
          (Producto producto) =>
              producto.categoria == CategoriaProducto.yogurts,
        ),
        isTrue,
      );

      final List<Producto> leches = CatalogoService.filtrar(
        categoria: CategoriaProducto.leches,
      );
      expect(leches.length, 4);
    });

    test('busca sin distinguir mayúsculas ni acentos', () {
      expect(CatalogoService.filtrar(texto: 'LECHE').length, 4);
      expect(CatalogoService.filtrar(texto: 'limon').length, 1);
      expect(CatalogoService.filtrar(texto: 'YOGURT').length, 9);
    });

    test('combina categoría y texto, o devuelve vacío', () {
      final List<Producto> resultado = CatalogoService.filtrar(
        categoria: CategoriaProducto.leches,
        texto: 'original',
      );

      expect(resultado.length, 1);
      expect(resultado.single.id, 'leche-soya-original');
      expect(CatalogoService.filtrar(texto: 'producto inexistente'), isEmpty);
    });

    test('formatea precios en bolivianos', () {
      expect(formatearPrecio(4), 'Bs 4,00');
      expect(formatearPrecio(13.5), 'Bs 13,50');
      expect(formatearPrecio(25), 'Bs 25,00');
    });
  });
}
