import 'package:material_ui/material_ui.dart';

import '../models/producto.dart';
import '../theme/app_theme.dart';
import '../utils/formato_moneda.dart';
import 'imagen_catalogo.dart';

class ProductoCard extends StatelessWidget {
  const ProductoCard({super.key, required this.producto, required this.onTap});

  final Producto producto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radio = BorderRadius.circular(NorlandRadius.lg);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radio,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NorlandColors.azulRey.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: NorlandColors.blanco,
        shape: RoundedRectangleBorder(
          borderRadius: radio,
          side: const BorderSide(color: NorlandColors.borde),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.38,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Hero(
                      tag: 'producto-${producto.id}',
                      child: ImagenCatalogo(
                        categoria: producto.categoria,
                        asset: producto.imagen,
                        iconSize: 34,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (producto.etiqueta != null)
                      Positioned(
                        top: 9,
                        left: 9,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: NorlandColors.blanco.withValues(alpha: 0.94),
                            borderRadius: BorderRadius.circular(
                              NorlandRadius.pill,
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: NorlandColors.azulRey.withValues(
                                  alpha: 0.08,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            producto.etiqueta!,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: producto.categoria.color,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 9.5,
                                ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        producto.categoria.etiqueta.toUpperCase(),
                        style: TextStyle(
                          color: producto.categoria.color,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        producto.nombre,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: NorlandColors.texto,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        producto.presentacion,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: NorlandColors.textoSecundario,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              formatearPrecio(producto.precio),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: NorlandColors.azulRey,
                                  ),
                            ),
                          ),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: NorlandColors.celesteSuave,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 15,
                              color: NorlandColors.azulRey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
