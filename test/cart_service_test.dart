import 'package:flutter_test/flutter_test.dart';
import 'package:nordland_puntos_venta/models/producto.dart';
import 'package:nordland_puntos_venta/services/cart_service.dart';
import 'package:nordland_puntos_venta/services/catalogo_service.dart';

void main() {
  group('CartService', () {
    late CartService cart;
    final Producto p1 = CatalogoService.productos[0]; // Agua Norland 20L (25 Bs)
    final Producto p2 = CatalogoService.productos[1]; // Helado Vasito (5 Bs)

    setUp(() {
      cart = CartService();
    });

    test('inicia vacío con 0 ítems y total 0', () {
      expect(cart.estaVacio, isTrue);
      expect(cart.cantidadTotal, 0);
      expect(cart.total, 0.0);
    });

    test('agrega productos e incrementa cantidades', () {
      cart.agregar(p1, cantidad: 2);
      expect(cart.estaVacio, isFalse);
      expect(cart.cantidadTotal, 2);
      expect(cart.cantidadDe(p1.id), 2);
      expect(cart.total, 50.0);

      cart.agregar(p1, cantidad: 1);
      expect(cart.cantidadTotal, 3);
      expect(cart.cantidadDe(p1.id), 3);
      expect(cart.total, 75.0);

      cart.agregar(p2, cantidad: 1);
      expect(cart.cantidadTotal, 4);
      expect(cart.itemTipoCount, 2);
      expect(cart.total, 80.0);
    });

    test('incrementa y decrementa productos', () {
      cart.agregar(p1, cantidad: 2);
      cart.incrementar(p1.id);
      expect(cart.cantidadDe(p1.id), 3);

      cart.decrementar(p1.id);
      expect(cart.cantidadDe(p1.id), 2);

      cart.decrementar(p1.id);
      expect(cart.cantidadDe(p1.id), 1);

      cart.decrementar(p1.id);
      expect(cart.cantidadDe(p1.id), 0);
      expect(cart.estaVacio, isTrue);
    });

    test('remover y vaciar carrito', () {
      cart.agregar(p1, cantidad: 2);
      cart.agregar(p2, cantidad: 3);
      expect(cart.cantidadTotal, 5);

      cart.remover(p1.id);
      expect(cart.cantidadDe(p1.id), 0);
      expect(cart.cantidadTotal, 3);

      cart.vaciar();
      expect(cart.estaVacio, isTrue);
      expect(cart.cantidadTotal, 0);
      expect(cart.total, 0.0);
    });
  });
}
