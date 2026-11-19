import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/tienda_registrada.dart';

/// Acceso a la base de datos local SQLite (equivalente a Room en Android).
class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static const String nombreBaseDatos = 'nordland_tiendas.db';
  static const String tablaTiendas = 'tiendas';
  static const int versionBaseDatos = 1;

  DatabaseFactory? _factoryPersonalizada;
  String? _rutaPersonalizada;
  Database? _baseDatos;

  /// Permite usar una fábrica en memoria durante las pruebas.
  @visibleForTesting
  void configurarParaPruebas(DatabaseFactory factory) {
    _factoryPersonalizada = factory;
    _rutaPersonalizada = inMemoryDatabasePath;
    _baseDatos = null;
  }

  Future<Database> get baseDatos async {
    final Database? existente = _baseDatos;
    if (existente != null && existente.isOpen) return existente;

    final String ruta =
        _rutaPersonalizada ?? p.join(await getDatabasesPath(), nombreBaseDatos);

    final Database abierta = await (_factoryPersonalizada ?? databaseFactory)
        .openDatabase(
          ruta,
          options: OpenDatabaseOptions(
            version: versionBaseDatos,
            onCreate: (Database db, int version) async {
              await db.execute('''
                CREATE TABLE $tablaTiendas (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  nombre_tienda TEXT NOT NULL,
                  propietario TEXT NOT NULL,
                  telefono TEXT NOT NULL,
                  latitud REAL NOT NULL,
                  longitud REAL NOT NULL,
                  foto_fachada TEXT,
                  creado_en TEXT NOT NULL
                )
              ''');
            },
          ),
        );

    _baseDatos = abierta;
    return abierta;
  }

  Future<int> guardarTienda(TiendaRegistrada tienda) async {
    final Database db = await baseDatos;
    return db.insert(tablaTiendas, tienda.toMap());
  }

  Future<List<TiendaRegistrada>> obtenerTiendas() async {
    final Database db = await baseDatos;
    final List<Map<String, Object?>> filas = await db.query(
      tablaTiendas,
      orderBy: 'creado_en DESC',
    );
    return filas.map(TiendaRegistrada.fromMap).toList(growable: false);
  }

  Future<int> contarTiendas() async {
    final Database db = await baseDatos;
    final int? total = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $tablaTiendas'),
    );
    return total ?? 0;
  }

  Future<int> eliminarTienda(int id) async {
    final Database db = await baseDatos;
    return db.delete(tablaTiendas, where: 'id = ?', whereArgs: <Object>[id]);
  }

  Future<void> eliminarTodasLasTiendas() async {
    final Database db = await baseDatos;
    await db.delete(tablaTiendas);
  }

  Future<void> cerrar() async {
    final Database? db = _baseDatos;
    _baseDatos = null;
    if (db != null && db.isOpen) {
      await db.close();
    }
  }
}
