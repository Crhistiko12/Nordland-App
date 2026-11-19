import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

/// Sello que identifica a los comercios oficiales de Nordland.
class PuntoOficialBadge extends StatelessWidget {
  const PuntoOficialBadge({
    super.key,
    this.compacto = false,
    this.fondoClaro = true,
  });

  final bool compacto;
  final bool fondoClaro;

  @override
  Widget build(BuildContext context) {
    final Color fondo = fondoClaro
        ? NorlandColors.verdeSuave
        : NorlandColors.blanco;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compacto ? 8 : 10,
        vertical: compacto ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(NorlandRadius.pill),
        border: Border.all(color: NorlandColors.verde.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.verified_rounded,
            size: compacto ? 13 : 15,
            color: NorlandColors.verde,
          ),
          SizedBox(width: compacto ? 4 : 5),
          Text(
            'Punto oficial',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: NorlandColors.verde,
              fontSize: compacto ? 10 : 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
