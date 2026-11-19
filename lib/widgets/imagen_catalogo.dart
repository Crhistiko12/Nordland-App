import 'package:material_ui/material_ui.dart';

import '../models/producto.dart';
import '../theme/app_theme.dart';

class ImagenCatalogo extends StatelessWidget {
  const ImagenCatalogo({
    super.key,
    required this.categoria,
    this.asset,
    this.iconSize = 38,
    this.fit = BoxFit.cover,
  });

  final CategoriaProducto categoria;
  final String? asset;
  final double iconSize;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (asset == null || asset!.trim().isEmpty) {
      return _RespaldoCategoria(categoria: categoria, iconSize: iconSize);
    }

    return Image.asset(
      asset!,
      width: double.infinity,
      height: double.infinity,
      fit: fit,
      filterQuality: FilterQuality.medium,
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
            return _RespaldoCategoria(categoria: categoria, iconSize: iconSize);
          },
    );
  }
}

class _RespaldoCategoria extends StatelessWidget {
  const _RespaldoCategoria({required this.categoria, required this.iconSize});

  final CategoriaProducto categoria;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[categoria.colorSuave, NorlandColors.blanco],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: -24,
            right: -20,
            child: _Burbuja(
              size: iconSize * 2.3,
              color: categoria.color.withValues(alpha: 0.09),
            ),
          ),
          Positioned(
            bottom: -18,
            left: -18,
            child: _Burbuja(
              size: iconSize * 1.8,
              color: categoria.color.withValues(alpha: 0.07),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: iconSize * 1.55,
                  height: iconSize * 1.55,
                  decoration: BoxDecoration(
                    color: NorlandColors.blanco,
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: categoria.color.withValues(alpha: 0.16),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    categoria.icono,
                    color: categoria.color,
                    size: iconSize,
                  ),
                ),
                SizedBox(height: iconSize * 0.16),
                Text(
                  categoria.etiqueta.toUpperCase(),
                  style: TextStyle(
                    color: categoria.color,
                    fontSize: iconSize * 0.26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Burbuja extends StatelessWidget {
  const _Burbuja({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
