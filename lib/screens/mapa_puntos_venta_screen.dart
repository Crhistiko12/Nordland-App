import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

import '../models/punto_de_venta.dart';
import '../services/maps_service.dart';
import '../services/puntos_venta_service.dart';
import '../theme/app_theme.dart';
import '../widgets/detalle_punto_venta_sheet.dart';
import '../widgets/nordland_logo.dart';
import '../widgets/pin_punto_venta.dart';
import '../widgets/punto_venta_card.dart';
import 'detalle_tienda_screen.dart';
import 'registro_punto_venta_screen.dart';

/// Pantalla principal: mapa y directorio de puntos de venta oficiales.
class MapaPuntosVentaScreen extends StatefulWidget {
  const MapaPuntosVentaScreen({super.key});

  @override
  State<MapaPuntosVentaScreen> createState() => _MapaPuntosVentaScreenState();
}

class _MapaPuntosVentaScreenState extends State<MapaPuntosVentaScreen> {
  static const MapsService _maps = MapsService();

  final PuntosVentaService _service = PuntosVentaService.instance;
  final MapController _mapController = MapController();

  List<PuntoVentaCercano> _puntos = PuntosVentaService.instance.cercanos();
  String _ciudadSeleccionada = 'Todas';
  String? _puntoSeleccionadoId;
  bool _mapaListo = false;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _seleccionarCiudad(String ciudad) {
    if (ciudad == _ciudadSeleccionada) return;

    setState(() {
      _ciudadSeleccionada = ciudad;
      _puntos = _service.cercanos(ciudad: ciudad);
      _puntoSeleccionadoId = null;
    });
    _ajustarMapa();
  }

  void _ajustarMapa() {
    if (!_mapaListo || _puntos.isEmpty) return;

    final Size pantalla = MediaQuery.sizeOf(context);
    final double paddingSuperior = MediaQuery.paddingOf(context).top + 145;
    final double paddingInferior = pantalla.height * 0.34 + 26;

    _mapController.fitCamera(
      CameraFit.coordinates(
        coordinates: _puntos
            .map((PuntoVentaCercano item) => item.punto.ubicacion)
            .toList(),
        padding: EdgeInsets.fromLTRB(42, paddingSuperior, 42, paddingInferior),
        maxZoom: 13.5,
      ),
    );
  }

  Future<void> _abrirDetalle(PuntoVentaCercano item) async {
    setState(() => _puntoSeleccionadoId = item.punto.id);
    if (_mapaListo) {
      _mapController.move(item.punto.ubicacion, 14.5);
    }

    final AccionDetallePuntoVenta? accion = await mostrarDetallePuntoVenta(
      context,
      item: item,
    );
    if (!mounted) return;

    if (accion == AccionDetallePuntoVenta.verFichaCompleta) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => DetalleTiendaScreen(
            punto: item.punto,
            distanciaKm: item.distanciaKm,
          ),
        ),
      );
      if (mounted && _mapaListo) {
        _mapController.move(item.punto.ubicacion, 14.5);
      }
    }
  }

  Future<void> _abrirRegistro() async {
    final MapCamera? camaraAnterior = _mapaListo ? _mapController.camera : null;

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const RegistroPuntoVentaScreen(),
      ),
    );

    if (mounted && camaraAnterior != null) {
      _mapController.move(camaraAnterior.center, camaraAnterior.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double altoPantalla = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: NorlandColors.fondo,
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(-17.2, -64.85),
              initialZoom: 6.2,
              minZoom: 4,
              maxZoom: 18,
              backgroundColor: NorlandColors.fondo,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
              onMapReady: () {
                _mapaListo = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _ajustarMapa();
                });
              },
              onTap: (_, _) {
                if (_puntoSeleccionadoId != null) {
                  setState(() => _puntoSeleccionadoId = null);
                }
              },
            ),
            children: <Widget>[
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'bo.com.nordland.nordland_puntos_venta',
                maxNativeZoom: 19,
              ),
              MarkerLayer(
                markers: <Marker>[
                  Marker(
                    point: PuntosVentaService.ubicacionReferencia,
                    width: 26,
                    height: 26,
                    child: Semantics(
                      label: 'Tu ubicación referencial',
                      child: Container(
                        decoration: BoxDecoration(
                          color: NorlandColors.celeste,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: NorlandColors.blanco,
                            width: 3,
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: NorlandColors.celeste.withValues(
                                alpha: 0.35,
                              ),
                              blurRadius: 10,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  for (final PuntoVentaCercano item in _puntos)
                    Marker(
                      point: item.punto.ubicacion,
                      width: 56,
                      height: 62,
                      alignment: Alignment.topCenter,
                      child: PinPuntoVenta(
                        nombre: item.punto.nombre,
                        seleccionado: item.punto.id == _puntoSeleccionadoId,
                        onTap: () => _abrirDetalle(item),
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                child: Column(
                  children: <Widget>[
                    _CabeceraMapa(onRegistro: _abrirRegistro),
                    const SizedBox(height: 10),
                    _FiltroCiudades(
                      ciudades: _service.ciudades,
                      seleccionada: _ciudadSeleccionada,
                      onSeleccionar: _seleccionarCiudad,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: altoPantalla * 0.34 + 46,
            child: _BotonMapa(
              tooltip: 'Ver todos los puntos',
              onTap: _ajustarMapa,
              icono: Icons.zoom_out_map_rounded,
            ),
          ),
          Positioned(
            right: 12,
            bottom: altoPantalla * 0.34 + 10,
            child: _AtribucionMapa(
              onTap: () async {
                final bool abierto = await _maps.abrirLicenciaOpenStreetMap();
                if (!abierto && context.mounted) {
                  mostrarErrorEnlace(context);
                }
              },
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.34,
            minChildSize: 0.15,
            maxChildSize: 0.9,
            snap: true,
            snapSizes: const <double>[0.15, 0.34, 0.9],
            builder:
                (BuildContext context, ScrollController scrollController) =>
                    _DirectorioSheet(
                      scrollController: scrollController,
                      puntos: _puntos,
                      ciudadSeleccionada: _ciudadSeleccionada,
                      puntoSeleccionadoId: _puntoSeleccionadoId,
                      onPuntoTap: _abrirDetalle,
                    ),
          ),
        ],
      ),
    );
  }
}

class _CabeceraMapa extends StatelessWidget {
  const _CabeceraMapa({required this.onRegistro});

  final VoidCallback onRegistro;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
      decoration: BoxDecoration(
        color: NorlandColors.blanco,
        borderRadius: BorderRadius.circular(NorlandRadius.lg),
        border: Border.all(color: NorlandColors.borde),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NorlandColors.azulRey.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          const NordlandLogo(height: 34),
          const SizedBox(width: 10),
          Container(width: 1, height: 30, color: NorlandColors.borde),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Puntos de Venta',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Oficiales · Bolivia',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRegistro,
            tooltip: 'Quiero ser punto de venta',
            style: IconButton.styleFrom(
              backgroundColor: NorlandColors.verde,
              foregroundColor: NorlandColors.blanco,
              fixedSize: const Size(44, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.add_business_rounded, size: 22),
          ),
        ],
      ),
    );
  }
}

class _FiltroCiudades extends StatelessWidget {
  const _FiltroCiudades({
    required this.ciudades,
    required this.seleccionada,
    required this.onSeleccionar,
  });

  final List<String> ciudades;
  final String seleccionada;
  final ValueChanged<String> onSeleccionar;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: ciudades.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (BuildContext context, int index) {
          final String ciudad = ciudades[index];
          final bool activa = ciudad == seleccionada;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSeleccionar(ciudad),
              borderRadius: BorderRadius.circular(NorlandRadius.pill),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: activa ? NorlandColors.azulRey : NorlandColors.blanco,
                  borderRadius: BorderRadius.circular(NorlandRadius.pill),
                  border: Border.all(
                    color: activa ? NorlandColors.azulRey : NorlandColors.borde,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: NorlandColors.azulRey.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  ciudad,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: activa
                        ? NorlandColors.blanco
                        : NorlandColors.azulRey,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DirectorioSheet extends StatelessWidget {
  const _DirectorioSheet({
    required this.scrollController,
    required this.puntos,
    required this.ciudadSeleccionada,
    required this.puntoSeleccionadoId,
    required this.onPuntoTap,
  });

  final ScrollController scrollController;
  final List<PuntoVentaCercano> puntos;
  final String ciudadSeleccionada;
  final String? puntoSeleccionadoId;
  final ValueChanged<PuntoVentaCercano> onPuntoTap;

  @override
  Widget build(BuildContext context) {
    final String titulo = ciudadSeleccionada == 'Todas'
        ? 'Puntos cerca de ti'
        : 'Puntos en $ciudadSeleccionada';

    return Container(
      decoration: BoxDecoration(
        color: NorlandColors.blanco,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(NorlandRadius.xl),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NorlandColors.azulRey.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(16, 9, 16, 28),
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
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      titulo,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Toca una tienda para ver detalles y cómo llegar.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: NorlandColors.verdeSuave,
                  borderRadius: BorderRadius.circular(NorlandRadius.pill),
                ),
                child: Text(
                  '${puntos.length} ${puntos.length == 1 ? 'punto' : 'puntos'}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: NorlandColors.verde,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (puntos.isEmpty)
            const _EstadoVacio()
          else
            for (final PuntoVentaCercano item in puntos)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PuntoVentaCard(
                  item: item,
                  seleccionado: item.punto.id == puntoSeleccionadoId,
                  onTap: () => onPuntoTap(item),
                ),
              ),
        ],
      ),
    );
  }
}

class _EstadoVacio extends StatelessWidget {
  const _EstadoVacio();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: NorlandColors.fondo,
        borderRadius: BorderRadius.circular(NorlandRadius.lg),
      ),
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.storefront_outlined,
            size: 36,
            color: NorlandColors.celeste,
          ),
          const SizedBox(height: 8),
          Text(
            'Aún no hay puntos en esta ciudad',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Pronto llevaremos la nutrición Nordland más cerca de ti.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _BotonMapa extends StatelessWidget {
  const _BotonMapa({
    required this.tooltip,
    required this.onTap,
    required this.icono,
  });

  final String tooltip;
  final VoidCallback onTap;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: NorlandColors.blanco,
        borderRadius: BorderRadius.circular(14),
        elevation: 3,
        shadowColor: NorlandColors.azulRey.withValues(alpha: 0.2),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 42,
            height: 42,
            child: Icon(icono, size: 20, color: NorlandColors.azulRey),
          ),
        ),
      ),
    );
  }
}

class _AtribucionMapa extends StatelessWidget {
  const _AtribucionMapa({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: NorlandColors.blanco.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Text(
            '© OpenStreetMap',
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(fontSize: 9, color: NorlandColors.textoSecundario),
          ),
        ),
      ),
    );
  }
}
