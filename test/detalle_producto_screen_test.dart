import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nordland_puntos_venta/screens/detalle_producto_screen.dart';
import 'package:nordland_puntos_venta/services/catalogo_service.dart';

void main() {
  testWidgets('muestra la información y el acceso al carrito', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: DetalleProductoScreen(producto: CatalogoService.productos.first),
      ),
    );
    await tester.pump();

    expect(find.text('Agua Norland 20L'), findsOneWidget);
    expect(find.text('Bs 25,00'), findsWidgets);
    expect(find.text('Agregar al carrito'), findsOneWidget);
    expect(find.text('Precio de revendedor'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
