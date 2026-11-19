import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nordland_puntos_venta/screens/carrito_screen.dart';
import 'package:nordland_puntos_venta/services/cart_service.dart';
import 'package:nordland_puntos_venta/services/catalogo_service.dart';
import 'package:nordland_puntos_venta/widgets/acciones_tienda_carrito.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('muestra los accesos de tienda y carrito con el contador', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final CartService cart = CartService()
      ..agregar(CatalogoService.productos.first, cantidad: 2)
      ..agregar(CatalogoService.productos[1]);

    await tester.pumpWidget(
      ChangeNotifierProvider<CartService>.value(
        value: cart,
        child: const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16),
              child: AccionesTiendaCarrito(),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Quiero ser Tienda Oficial'), findsOneWidget);
    expect(find.text('Ver mi Carrito (3 productos)'), findsOneWidget);

    await tester.tap(find.text('Ver mi Carrito (3 productos)'));
    await tester.pumpAndSettle();

    expect(find.byType(CarritoScreen), findsOneWidget);
    expect(find.text('Mi Carrito'), findsOneWidget);
  });
}
