import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nordland_puntos_venta/screens/galeria_screen.dart';
import 'package:nordland_puntos_venta/screens/nosotros_screen.dart';
import 'package:nordland_puntos_venta/services/cart_service.dart';
import 'package:provider/provider.dart';

Widget _app(Widget home) {
  return ChangeNotifierProvider<CartService>(
    create: (_) => CartService(),
    child: MaterialApp(home: home),
  );
}

void main() {
  testWidgets('Nosotros y QR se renderizan en escritorio', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_app(const NosotrosScreen()));
    await tester.pump();

    expect(find.text('Nutrición que te mueve'), findsWidgets);

    await tester.tap(find.byIcon(Icons.qr_code_2_rounded).first);
    await tester.pumpAndSettle();

    expect(find.text('Escanea para descargar la app móvil'), findsOneWidget);
    expect(find.bySemanticsLabel('Código QR de Nordland'), findsOneWidget);

    await tester.tap(find.text('Cerrar'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).first, const Offset(0, -700));
    await tester.pumpAndSettle();

    expect(find.text('MISIÓN'), findsOneWidget);
    expect(find.text('VISIÓN'), findsOneWidget);
  });

  testWidgets('Galería se renderiza en móvil', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_app(const GaleriaScreen()));
    await tester.pump();

    expect(find.text('Galería Nordland'), findsOneWidget);
    expect(find.text('Agua Norland 20L'), findsOneWidget);
  });
}
