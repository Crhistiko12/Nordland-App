import 'package:material_ui/material_ui.dart';

import '../models/producto.dart';
import '../theme/app_theme.dart';
import 'imagen_catalogo.dart';

class CategoriaCard extends StatelessWidget {
  const CategoriaCard({
    super.key,
    required this.categoria,
    required this.seleccionada,
    required this.onTap,
  });

  final CategoriaProducto categoria;
  final bool seleccionada;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radio = BorderRadius.circular(NorlandRadius.md);

    return Material(
      color: seleccionada ? categoria.colorSuave : NorlandColors.blanco,
      shape: RoundedRectangleBorder(
        borderRadius: radio,
        side: BorderSide(
          color: seleccionada
              ? categoria.color.withValues(alpha: 0.55)
              : NorlandColors.borde,
          width: seleccionada ? 1.4 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(NorlandRadius.sm),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      ImagenCatalogo(categoria: categoria, iconSize: 27),
                      if (seleccionada)
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: categoria.color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: NorlandColors.blanco,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 11,
                              color: NorlandColors.blanco,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                categoria.etiqueta,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: seleccionada ? categoria.color : NorlandColors.texto,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
