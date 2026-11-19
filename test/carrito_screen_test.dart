import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nordland_puntos_venta/screens/carrito_screen.dart';
import 'package:nordland_puntos_venta/screens/seguimiento_screen.dart';
import 'package:nordland_puntos_venta/services/cart_service.dart';
import 'package:nordland_puntos_venta/services/catalogo_service.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('muestra estado vacío y luego productos al agregar', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final CartService cart = CartService();

    await tester.pumpWidget(
      ChangeNotifierProvider<CartService>.value(
        value: cart,
        child: const MaterialApp(
          home: CarritoScreen(),
        ),
      ),
    );
    await tester.pump();

    // Estado vacío
    expect(find.text('Tu carrito está vacío'), findsOneWidget);
    expect(find.text('Explorar catálogo'), findsOneWidget);

    // Agregar producto
    cart.agregar(CatalogoService.productos.first, cantidad: 2);
    await tester.pump();

    expect(find.text('Tu carrito está vacío'), findsNothing);
    expect(find.text('Agua Norland 20L'), findsOneWidget);
    expect(find.text('Confirmar Pedido'), findsOneWidget);
    expect(find.textContaining('Total (2 productos):'), findsOneWidget);

    // Al confirmar el pedido debe vaciar el carrito y navegar
    await tester.tap(find.text('Confirmar Pedido'));
    await tester.pumpAndSettle();

    expect(find.byType(SeguimientoScreen), findsOneWidget);
    expect(cart.estaVacio, isTrue);
  });
}
