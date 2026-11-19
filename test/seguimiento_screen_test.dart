import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nordland_puntos_venta/screens/seguimiento_screen.dart';

void main() {
  testWidgets('muestra el cronómetro y el botón de simulación < 200m', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: SeguimientoScreen(
          duracionInicial: Duration(hours: 24),
        ),
      ),
    );
    await tester.pump();

    // Título y estado
    expect(find.text('Seguimiento del Pedido'), findsOneWidget);
    expect(find.text('Pedido en camino'), findsOneWidget);

    // Cronómetro inicial
    expect(find.textContaining('Llegará en 24:00:00'), findsOneWidget);

    // Avanzamos 1 segundo
    await tester.pump(const Duration(seconds: 1));
    expect(find.textContaining('Llegará en 23:59:59'), findsOneWidget);

    // Botón de simulación
    expect(find.text('Simular < 200m'), findsOneWidget);

    // Presionamos el botón de simulación
    await tester.tap(find.text('Simular < 200m'));
    await tester.pumpAndSettle();

    // Debe mostrarse el AlertDialog con el mensaje
    expect(find.text('¡Pedido a menos de 200m!'), findsOneWidget);
    expect(
      find.textContaining('¡Tu pedido Norland está a menos de 200 metros!'),
      findsOneWidget,
    );

    // Cerrar el diálogo
    await tester.tap(find.text('¡Entendido, salgo a recibir!'));
    await tester.pumpAndSettle();

    expect(find.text('¡Pedido a menos de 200m!'), findsNothing);
  });
}
