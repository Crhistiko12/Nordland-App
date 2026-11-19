import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

/// Avatar con las iniciales de la tienda y un pequeño sello de hoja Nordland.
class AvatarTienda extends StatelessWidget {
  const AvatarTienda({
    super.key,
    required this.iniciales,
    this.tamano = 54,
    this.mostrarHoja = true,
  });

  final String iniciales;
  final double tamano;
  final bool mostrarHoja;

  @override
  Widget build(BuildContext context) {
    final double tamanoHoja = tamano * 0.36;

    return SizedBox(
      width: tamano,
      height: tamano,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            width: tamano,
            height: tamano,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  NorlandColors.blanco,
                  NorlandColors.celesteSuave,
                ],
              ),
              borderRadius: BorderRadius.circular(tamano * 0.32),
              border: Border.all(color: NorlandColors.blanco, width: 2),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: NorlandColors.azulRey.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              iniciales,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: tamano * 0.32,
                color: NorlandColors.azulRey,
              ),
            ),
          ),
          if (mostrarHoja)
            Positioned(
              right: -3,
              bottom: -3,
              child: Container(
                width: tamanoHoja,
                height: tamanoHoja,
                decoration: BoxDecoration(
                  color: NorlandColors.verde,
                  shape: BoxShape.circle,
                  border: Border.all(color: NorlandColors.blanco, width: 2),
                ),
                child: Icon(
                  Icons.eco_rounded,
                  color: NorlandColors.blanco,
                  size: tamanoHoja * 0.62,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
