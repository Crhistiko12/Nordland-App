import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

enum CategoriaProducto {
  agua(
    etiqueta: 'Agua',
    icono: Icons.water_drop_rounded,
    color: NorlandColors.celeste,
    colorSuave: NorlandColors.celesteSuave,
  ),
  helados(
    etiqueta: 'Helados',
    icono: Icons.icecream_rounded,
    color: NorlandColors.naranja,
    colorSuave: NorlandColors.naranjaSuave,
  ),
  leches(
    etiqueta: 'Leches',
    icono: Icons.local_drink_rounded,
    color: NorlandColors.azulRey,
    colorSuave: NorlandColors.celesteSuave,
  ),
  yogurts(
    etiqueta: 'Yogurts',
    icono: Icons.emoji_food_beverage_rounded,
    color: NorlandColors.verde,
    colorSuave: NorlandColors.verdeSuave,
  );

  const CategoriaProducto({
    required this.etiqueta,
    required this.icono,
    required this.color,
    required this.colorSuave,
  });

  final String etiqueta;
  final IconData icono;
  final Color color;
  final Color colorSuave;
}

class Producto {
  const Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.presentacion,
    required this.precio,
    required this.precioMayorista,
    required this.descripcion,
    this.etiqueta,
    this.imagen,
  });

  final String id;
  final String nombre;
  final CategoriaProducto categoria;
  final String presentacion;
  final double precio;
  final double precioMayorista;
  final String descripcion;
  final String? etiqueta;
  final String? imagen;

  String get imagenAsset => imagen ?? '';
}
