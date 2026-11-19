import 'package:material_ui/material_ui.dart';

import '../models/punto_de_venta.dart';
import '../services/puntos_venta_service.dart';
import '../theme/app_theme.dart';
import 'avatar_tienda.dart';
import 'calificacion_estrellas.dart';

/// Tarjeta de un punto de venta dentro del directorio.
class PuntoVentaCard extends StatelessWidget {
  const PuntoVentaCard({
    super.key,
    required this.item,
    required this.onTap,
    this.seleccionado = false,
  });

  final PuntoVentaCercano item;
  final VoidCallback onTap;
  final bool seleccionado;

  @override
  Widget build(BuildContext context) {
    final PuntoDeVenta punto = item.punto;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: seleccionado ? NorlandColors.celesteSuave : NorlandColors.blanco,
        borderRadius: BorderRadius.circular(NorlandRadius.lg),
        border: Border.all(
          color: seleccionado ? NorlandColors.celeste : NorlandColors.borde,
          width: seleccionado ? 1.6 : 1,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NorlandColors.azulRey.withValues(
              alpha: seleccionado ? 0.1 : 0.05,
            ),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(NorlandRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(NorlandRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AvatarTienda(iniciales: punto.iniciales, tamano: 52),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        punto.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: NorlandColors.celeste,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              punto.direccion,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(width: 6),
                          _DistanciaChip(distanciaKm: item.distanciaKm),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: punto.abierto
                                  ? NorlandColors.verde
                                  : NorlandColors.textoSecundario,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            punto.abierto ? 'Abierto' : 'Cerrado',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: punto.abierto
                                      ? NorlandColors.verde
                                      : NorlandColors.textoSecundario,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 1,
                            height: 11,
                            color: NorlandColors.borde,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              punto.ciudad,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CalificacionEstrellas(
                            calificacion: punto.calificacion,
                            tamano: 13,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DistanciaChip extends StatelessWidget {
  const _DistanciaChip({required this.distanciaKm});

  final double distanciaKm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: NorlandColors.blanco,
        borderRadius: BorderRadius.circular(NorlandRadius.pill),
        border: Border.all(color: NorlandColors.celeste.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.near_me_rounded,
            size: 11,
            color: NorlandColors.celeste,
          ),
          const SizedBox(width: 3),
          Text(
            PuntosVentaService.formatearDistancia(distanciaKm),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: NorlandColors.azulRey,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
