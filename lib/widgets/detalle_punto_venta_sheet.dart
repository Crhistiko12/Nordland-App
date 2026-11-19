import 'package:material_ui/material_ui.dart';

import '../models/punto_de_venta.dart';
import '../services/maps_service.dart';
import '../services/puntos_venta_service.dart';
import '../theme/app_theme.dart';
import 'avatar_tienda.dart';
import 'calificacion_estrellas.dart';
import 'punto_oficial_badge.dart';

enum AccionDetallePuntoVenta { verFichaCompleta }

/// Muestra la tarjeta deslizable con el resumen del punto de venta.
Future<AccionDetallePuntoVenta?> mostrarDetallePuntoVenta(
  BuildContext context, {
  required PuntoVentaCercano item,
}) {
  return showModalBottomSheet<AccionDetallePuntoVenta>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x59101828),
    builder: (BuildContext context) => _DetallePuntoVentaSheet(item: item),
  );
}

class _DetallePuntoVentaSheet extends StatelessWidget {
  const _DetallePuntoVentaSheet({required this.item});

  final PuntoVentaCercano item;

  @override
  Widget build(BuildContext context) {
    final PuntoDeVenta punto = item.punto;
    final double altoMaximo = MediaQuery.sizeOf(context).height * 0.9;
    const MapsService maps = MapsService();

    return Container(
      constraints: BoxConstraints(maxHeight: altoMaximo),
      decoration: const BoxDecoration(
        color: NorlandColors.blanco,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(NorlandRadius.xl),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: NorlandColors.borde,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AvatarTienda(iniciales: punto.iniciales, tamano: 58),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          punto.nombre,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            PuntoOficialBadge(compacto: true),
                            Text(
                              '${punto.zona} · ${punto.ciudad}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        CalificacionEstrellas(
                          calificacion: punto.calificacion,
                          totalResenas: punto.totalResenas,
                          tamano: 14,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Cerrar',
                    style: IconButton.styleFrom(
                      backgroundColor: NorlandColors.fondo,
                      foregroundColor: NorlandColors.azulRey,
                    ),
                    icon: const Icon(Icons.close_rounded, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: NorlandColors.fondo,
                  borderRadius: BorderRadius.circular(NorlandRadius.md),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.location_on_rounded,
                      color: NorlandColors.celeste,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        punto.direccion,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      PuntosVentaService.formatearDistancia(item.distanciaKm),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: NorlandColors.celeste,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _InfoLinea(
                icono: Icons.schedule_rounded,
                etiqueta: 'Horario',
                valor: punto.horario,
                color: NorlandColors.verde,
              ),
              const SizedBox(height: 10),
              _InfoLinea(
                icono: Icons.phone_rounded,
                etiqueta: 'Teléfono',
                valor: punto.telefono,
                color: NorlandColors.celeste,
                onTap: () async {
                  final bool abierto = await maps.llamar(punto.telefono);
                  if (!abierto && context.mounted) {
                    mostrarErrorEnlace(context);
                  }
                },
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: NorlandColors.verdeSuave,
                  borderRadius: BorderRadius.circular(NorlandRadius.md),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.eco_rounded,
                      color: NorlandColors.verde,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${punto.productos.length} productos Nordland disponibles',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: NorlandColors.verde,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: NorlandColors.naranja,
                    foregroundColor: NorlandColors.blanco,
                  ),
                  onPressed: () async {
                    final bool abierto = await maps.abrirEnGoogleMaps(
                      punto.ubicacion,
                    );
                    if (!abierto && context.mounted) {
                      mostrarErrorEnlace(context);
                    }
                  },
                  icon: const Icon(Icons.directions_rounded, size: 20),
                  label: const Text('Cómo llegar'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () =>
                      Navigator.of(context)
                          .pop(AccionDetallePuntoVenta.verFichaCompleta),
                  icon: const Icon(Icons.storefront_rounded, size: 19),
                  label: const Text('Ver ficha completa'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoLinea extends StatelessWidget {
  const _InfoLinea({
    required this.icono,
    required this.etiqueta,
    required this.valor,
    required this.color,
    this.onTap,
  });

  final IconData icono;
  final String etiqueta;
  final String valor;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget contenido = Row(
      children: <Widget>[
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icono, size: 18, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(etiqueta, style: Theme.of(context).textTheme.labelSmall),
              Text(
                valor,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ],
          ),
        ),
        if (onTap != null)
          Icon(
            Icons.chevron_right_rounded,
            color: NorlandColors.textoSecundario,
            size: 20,
          ),
      ],
    );

    if (onTap == null) return contenido;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(NorlandRadius.sm),
      child: contenido,
    );
  }
}
