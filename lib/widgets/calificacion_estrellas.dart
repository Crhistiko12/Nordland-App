import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

/// Calificación en estrellas con la cantidad de reseñas.
class CalificacionEstrellas extends StatelessWidget {
  const CalificacionEstrellas({
    super.key,
    required this.calificacion,
    this.totalResenas,
    this.tamano = 14,
  });

  final double calificacion;
  final int? totalResenas;
  final double tamano;

  @override
  Widget build(BuildContext context) {
    final TextStyle? estilo = Theme.of(context).textTheme.labelSmall?.copyWith(
      color: NorlandColors.azulRey,
      fontWeight: FontWeight.w800,
      fontSize: tamano - 2,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 1; i <= 5; i++)
          Icon(
            calificacion >= i
                ? Icons.star_rounded
                : calificacion >= i - 0.5
                ? Icons.star_half_rounded
                : Icons.star_outline_rounded,
            size: tamano,
            color: calificacion >= i - 0.5
                ? NorlandColors.amarillo
                : NorlandColors.borde,
          ),
        const SizedBox(width: 4),
        Text(
          calificacion.toStringAsFixed(1).replaceAll('.', ','),
          style: estilo,
        ),
        if (totalResenas != null) ...<Widget>[
          const SizedBox(width: 3),
          Text(
            '($totalResenas)',
            style: estilo?.copyWith(
              color: NorlandColors.textoSecundario,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
