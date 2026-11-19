import 'package:material_ui/material_ui.dart';

import '../models/producto_nordland.dart';
import '../theme/app_theme.dart';

/// Tarjeta compacta de un producto Nordland disponible en la tienda.
class ProductoNordlandCard extends StatelessWidget {
  const ProductoNordlandCard({super.key, required this.producto});

  final ProductoNordland producto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: NorlandColors.blanco,
        borderRadius: BorderRadius.circular(NorlandRadius.lg),
        border: Border.all(color: NorlandColors.borde),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NorlandColors.azulRey.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: producto.color.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(producto.icono, color: producto.color, size: 21),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: NorlandColors.verdeSuave,
                  borderRadius: BorderRadius.circular(NorlandRadius.pill),
                ),
                child: Text(
                  'Disponible',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: NorlandColors.verde,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            producto.nombre,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall
                ?.copyWith(fontSize: 13.5, height: 1.2),
          ),
          const SizedBox(height: 3),
          Text(
            producto.presentacion,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
