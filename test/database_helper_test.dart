import 'package:flutter_test/flutter_test.dart';
import 'package:nordland_puntos_venta/models/tienda_registrada.dart';
import 'package:nordland_puntos_venta/services/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  final DatabaseHelper helper = DatabaseHelper.instance;

  setUpAll(sqfliteFfiInit);

  setUp(() {
    helper.configurarParaPruebas(databaseFactoryFfi);
  });

  tearDown(() async {
    await helper.cerrar();
  });

  TiendaRegistrada tiendaDemo() {
    return TiendaRegistrada(
      nombreTienda: 'Minimarket El Sol',
      propietario: 'Ana Pérez',
      telefono: '71234567',
      latitud: -17.3895,
      longitud: -66.1568,
      fotoFachada: '/datos/fachada.jpg',
      creadoEn: DateTime(2026, 11, 19, 10, 30),
    );
  }

  test('guarda una tienda con coordenadas y foto en SQLite', () async {
    final int id = await helper.guardarTienda(tiendaDemo());
    expect(id, greaterThan(0));

    final List<TiendaRegistrada> tiendas = await helper.obtenerTiendas();
    expect(tiendas, hasLength(1));

    final TiendaRegistrada guardada = tiendas.single;
    expect(guardada.id, id);
    expect(guardada.nombreTienda, 'Minimarket El Sol');
    expect(guardada.propietario, 'Ana Pérez');
    expect(guardada.telefono, '71234567');
    expect(guardada.latitud, closeTo(-17.3895, 0.00001));
    expect(guardada.longitud, closeTo(-66.1568, 0.00001));
    expect(guardada.fotoFachada, '/datos/fachada.jpg');
    expect(guardada.creadoEn, DateTime(2026, 11, 19, 10, 30));
  });

  test('cuenta, elimina y lista varias tiendas', () async {
    await helper.guardarTienda(tiendaDemo());
    await helper.guardarTienda(
      TiendaRegistrada(
        nombreTienda: 'Tienda Central',
        propietario: 'Luis Rojas',
        telefono: '70000000',
        latitud: -17.4,
        longitud: -66.2,
        creadoEn: DateTime(2026, 11, 20),
      ),
    );

    expect(await helper.contarTiendas(), 2);

    final List<TiendaRegistrada> tiendas = await helper.obtenerTiendas();
    expect(tiendas.first.nombreTienda, 'Tienda Central');
    expect(tiendas.last.fotoFachada, '/datos/fachada.jpg');

    await helper.eliminarTienda(tiendas.first.id!);
    expect(await helper.contarTiendas(), 1);

    await helper.eliminarTodasLasTiendas();
    expect(await helper.contarTiendas(), 0);
  });
}
