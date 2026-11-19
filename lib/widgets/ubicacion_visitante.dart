import 'package:material_ui/material_ui.dart';

import '../services/ubicacion_service.dart';
import '../theme/app_theme.dart';

/// Indicador de ubicación mostrado debajo del AppBar de la pantalla de inicio.
class UbicacionVisitante extends StatefulWidget {
  const UbicacionVisitante({super.key});

  @override
  State<UbicacionVisitante> createState() => _UbicacionVisitanteState();
}

class _UbicacionVisitanteState extends State<UbicacionVisitante> {
  bool _cargando = true;
  UbicacionDetectada? _ubicacion;

  @override
  void initState() {
    super.initState();
    _detectar();
  }

  Future<void> _detectar() async {
    setState(() => _cargando = true);

    final UbicacionDetectada? ubicacion =
        await UbicacionService.obtenerUbicacion();
    if (!mounted) return;

    setState(() {
      _ubicacion = ubicacion;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool disponible = _ubicacion != null;
    final Color color = disponible
        ? NorlandColors.verde
        : NorlandColors.textoSecundario;
    final Color fondo = disponible
        ? NorlandColors.verdeSuave
        : NorlandColors.fondo;
    final Color borde = disponible
        ? NorlandColors.verde.withValues(alpha: 0.25)
        : NorlandColors.borde;

    final String texto;
    if (_cargando) {
      texto = '📍 Obteniendo tu ubicación...';
    } else if (disponible) {
      texto = '📍 Estás visitando desde: ${_ubicacion!.descripcion}';
    } else {
      texto = '📍 Ubicación no disponible';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 6, 8),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(NorlandRadius.md),
        border: Border.all(color: borde),
      ),
      child: Row(
        children: <Widget>[
          if (_cargando)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: NorlandColors.azulRey,
              ),
            )
          else
            Icon(Icons.location_on_rounded, size: 18, color: color),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              texto,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: disponible ? NorlandColors.verde : color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (!_cargando)
            IconButton(
              tooltip: 'Actualizar ubicación',
              onPressed: _detectar,
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
              padding: EdgeInsets.zero,
              icon: Icon(Icons.refresh_rounded, size: 18, color: color),
            ),
        ],
      ),
    );
  }
}
