import 'package:material_ui/material_ui.dart';

import '../models/punto_de_venta.dart';
import '../services/maps_service.dart';
import '../services/puntos_venta_service.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar_tienda.dart';
import '../widgets/calificacion_estrellas.dart';
import '../widgets/nordland_logo.dart';
import '../widgets/norland_waves.dart';
import '../widgets/producto_nordland_card.dart';
import '../widgets/punto_oficial_badge.dart';

/// Ficha completa de un punto de venta oficial.
class DetalleTiendaScreen extends StatelessWidget {
  const DetalleTiendaScreen({super.key, required this.punto, this.distanciaKm});

  final PuntoDeVenta punto;
  final double? distanciaKm;

  static const MapsService _maps = MapsService();

  @override
  Widget build(BuildContext context) {
    final double distancia =
        distanciaKm ?? PuntosVentaService.instance.distanciaKm(punto);

    return Scaffold(
      backgroundColor: NorlandColors.blanco,
      appBar: AppBar(
        title: const Text('Punto de venta'),
        actions: <Widget>[
          IconButton(
            onPressed: () => _llamar(context),
            tooltip: 'Llamar a la tienda',
            icon: const Icon(Icons.phone_rounded, size: 21),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: <Widget>[
          _CabeceraTienda(punto: punto, distancia: distancia),
          const SizedBox(height: 22),
          const _TituloSeccion(
            titulo: 'Información de la tienda',
            subtitulo: 'Datos para que puedas visitarla o contactarla.',
          ),
          const SizedBox(height: 12),
          _TarjetaContacto(
            punto: punto,
            onLlamar: () => _llamar(context),
            onWhatsApp: () => _abrirWhatsApp(context),
          ),
          const SizedBox(height: 24),
          _TituloSeccion(
            titulo: 'Productos disponibles',
            subtitulo:
                '${punto.productos.length} opciones Nordland en esta tienda.',
            chip: '100% vegetal',
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double anchoTarjeta = (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  for (final producto in punto.productos)
                    SizedBox(
                      width: anchoTarjeta,
                      child: ProductoNordlandCard(producto: producto),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NorlandColors.verdeSuave,
              borderRadius: BorderRadius.circular(NorlandRadius.lg),
              border: Border.all(
                color: NorlandColors.verde.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: NorlandColors.verde,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.eco_rounded,
                    color: NorlandColors.blanco,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Punto de venta verificado',
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(color: NorlandColors.verde),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Este comercio forma parte del directorio oficial de '
                        'Nordland. Encuentra aquí tus productos de soya '
                        'favoritos.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: NorlandColors.verde,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _AccionesInferiores(
        onWhatsApp: () => _abrirWhatsApp(context),
        onMapa: () => _abrirMapa(context),
      ),
    );
  }

  Future<void> _abrirWhatsApp(BuildContext context) async {
    final bool abierto = await _maps.contactarWhatsApp(punto.telefono);
    if (!context.mounted) return;
    if (!abierto) mostrarErrorEnlace(context);
  }

  Future<void> _abrirMapa(BuildContext context) async {
    final bool abierto = await _maps.abrirEnGoogleMaps(punto.ubicacion);
    if (!context.mounted) return;
    if (!abierto) mostrarErrorEnlace(context);
  }

  Future<void> _llamar(BuildContext context) async {
    final bool abierto = await _maps.llamar(punto.telefono);
    if (!context.mounted) return;
    if (!abierto) mostrarErrorEnlace(context);
  }
}

class _CabeceraTienda extends StatelessWidget {
  const _CabeceraTienda({required this.punto, required this.distancia});

  final PuntoDeVenta punto;
  final double distancia;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(NorlandRadius.xl),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[NorlandColors.azulRey, NorlandColors.celeste],
          ),
        ),
        child: Stack(
          children: <Widget>[
            const Positioned.fill(
              child: IgnorePointer(
                child: NorlandWaves(
                  colorAzul: NorlandColors.blanco,
                  colorVerde: NorlandColors.blanco,
                ),
              ),
            ),
            Positioned(
              top: -30,
              right: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NorlandColors.blanco.withValues(alpha: 0.07),
                ),
              ),
            ),
            Positioned(
              bottom: 34,
              left: -26,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NorlandColors.amarillo.withValues(alpha: 0.14),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: NorlandColors.blanco,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const NordlandLogo(height: 22),
                      ),
                      const Spacer(),
                      const PuntoOficialBadge(compacto: true),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AvatarTienda(iniciales: punto.iniciales, tamano: 66),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              punto.nombre,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: NorlandColors.blanco,
                                    fontSize: 23,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 14,
                                  color: NorlandColors.blanco,
                                ),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    '${punto.zona} · ${punto.ciudad}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: NorlandColors.blanco
                                              .withValues(alpha: 0.86),
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: NorlandColors.blanco,
                          borderRadius: BorderRadius.circular(
                            NorlandRadius.pill,
                          ),
                        ),
                        child: CalificacionEstrellas(
                          calificacion: punto.calificacion,
                          totalResenas: punto.totalResenas,
                          tamano: 14,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: NorlandColors.blanco.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(
                            NorlandRadius.pill,
                          ),
                          border: Border.all(
                            color: NorlandColors.blanco.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Icon(
                              Icons.near_me_rounded,
                              size: 12,
                              color: NorlandColors.blanco,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'a ${PuntosVentaService.formatearDistancia(distancia)}',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: NorlandColors.blanco,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    punto.direccion,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: NorlandColors.blanco.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaContacto extends StatelessWidget {
  const _TarjetaContacto({
    required this.punto,
    required this.onLlamar,
    required this.onWhatsApp,
  });

  final PuntoDeVenta punto;
  final VoidCallback onLlamar;
  final VoidCallback onWhatsApp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NorlandColors.blanco,
        borderRadius: BorderRadius.circular(NorlandRadius.lg),
        border: Border.all(color: NorlandColors.borde),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NorlandColors.azulRey.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          _FilaContacto(
            icono: Icons.person_rounded,
            color: NorlandColors.azulRey,
            etiqueta: 'Atendido por',
            valor: punto.propietario,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          _FilaContacto(
            icono: Icons.schedule_rounded,
            color: NorlandColors.verde,
            etiqueta: 'Horario de atención',
            valor: punto.horario,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          _FilaContacto(
            icono: Icons.phone_rounded,
            color: NorlandColors.celeste,
            etiqueta: 'Teléfono',
            valor: punto.telefono,
            acciones: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _MiniAccion(
                  icono: Icons.call_rounded,
                  color: NorlandColors.verde,
                  tooltip: 'Llamar',
                  onTap: onLlamar,
                ),
                const SizedBox(width: 6),
                _MiniAccion(
                  icono: Icons.chat_bubble_rounded,
                  color: NorlandColors.celeste,
                  tooltip: 'WhatsApp',
                  onTap: onWhatsApp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaContacto extends StatelessWidget {
  const _FilaContacto({
    required this.icono,
    required this.color,
    required this.etiqueta,
    required this.valor,
    this.acciones,
  });

  final IconData icono;
  final Color color;
  final String etiqueta;
  final String valor;
  final Widget? acciones;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.11),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icono, color: color, size: 20),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(etiqueta, style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 1),
              Text(
                valor,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w700, fontSize: 13.5),
              ),
            ],
          ),
        ),
        if (acciones != null) ...<Widget>[const SizedBox(width: 8), acciones!],
      ],
    );
  }
}

class _MiniAccion extends StatelessWidget {
  const _MiniAccion({
    required this.icono,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icono;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icono, size: 17, color: color),
        ),
      ),
    );
  }
}

class _TituloSeccion extends StatelessWidget {
  const _TituloSeccion({
    required this.titulo,
    required this.subtitulo,
    this.chip,
  });

  final String titulo;
  final String subtitulo;
  final String? chip;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                titulo,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (chip != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: NorlandColors.verdeSuave,
                  borderRadius: BorderRadius.circular(NorlandRadius.pill),
                ),
                child: Text(
                  chip!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: NorlandColors.verde,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 3),
        Text(subtitulo, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _AccionesInferiores extends StatelessWidget {
  const _AccionesInferiores({required this.onWhatsApp, required this.onMapa});

  final VoidCallback onWhatsApp;
  final VoidCallback onMapa;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NorlandColors.blanco,
        border: const Border(top: BorderSide(color: NorlandColors.borde)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NorlandColors.azulRey.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: NorlandColors.azulRey,
                    foregroundColor: NorlandColors.blanco,
                  ),
                  onPressed: onWhatsApp,
                  icon: const Icon(Icons.chat_bubble_rounded, size: 19),
                  label: const Text('Contactar por WhatsApp'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: NorlandColors.blanco,
                    foregroundColor: NorlandColors.azulRey,
                    side: const BorderSide(
                      color: NorlandColors.celeste,
                      width: 1.5,
                    ),
                  ),
                  onPressed: onMapa,
                  icon: const Icon(Icons.map_outlined, size: 19),
                  label: const Text('Ver en Google Maps'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
