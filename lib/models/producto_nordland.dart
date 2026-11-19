import 'package:material_ui/material_ui.dart';

/// Producto del catálogo Nordland disponible en un punto de venta.
class ProductoNordland {
  const ProductoNordland({
    required this.id,
    required this.nombre,
    required this.presentacion,
    required this.icono,
    required this.color,
  });

  final String id;
  final String nombre;
  final String presentacion;
  final IconData icono;
  final Color color;
}
