import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

/// Selector de ubicación simulado sobre OpenStreetMap.
///
/// El usuario mueve el mapa, el pin permanece al centro y al confirmar se
/// devuelven las coordenadas exactas del centro del mapa.
class SelectorUbicacionScreen extends StatefulWidget {
  const SelectorUbicacionScreen({super.key, this.ubicacionInicial});

  final LatLng? ubicacionInicial;

  @override
  State<SelectorUbicacionScreen> createState() =>
      _SelectorUbicacionScreenState();
}

class _SelectorUbicacionScreenState extends State<SelectorUbicacionScreen> {
  static const LatLng _centroCochabamba = LatLng(-17.3895, -66.1568);

  final MapController _mapController = MapController();

  late final LatLng _inicial = widget.ubicacionInicial ?? _centroCochabamba;
  LatLng _centroActual = _centroCochabamba;
  bool _mapaListo = false;

  @override
  void initState() {
    super.initState();
    _centroActual = _inicial;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _confirmar() {
    final LatLng centro = _mapaListo
        ? _mapController.camera.center
        : _centroActual;
    Navigator.of(context).pop(centro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NorlandColors.fondo,
      appBar: AppBar(title: const Text('Ubicación de la tienda')),
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _inicial,
              initialZoom: 15,
              minZoom: 4,
              maxZoom: 18,
              backgroundColor: NorlandColors.fondo,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
              onMapReady: () => _mapaListo = true,
              onPositionChanged: (MapCamera camera, bool _) {
                _centroActual = camera.center;
              },
              onTap: (_, LatLng punto) {
                _mapController.move(punto, _mapController.camera.zoom);
              },
            ),
            children: <Widget>[
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'bo.com.nordland.nordland_puntos_venta',
                maxNativeZoom: 19,
              ),
            ],
          ),
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: SafeArea(
              bottom: false,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: NorlandColors.blanco,
                  borderRadius: BorderRadius.circular(NorlandRadius.md),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: NorlandColors.azulRey.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: NorlandColors.celesteSuave,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.touch_app_rounded,
                        size: 19,
                        color: NorlandColors.celeste,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Mueve el mapa o toca un punto para ubicar tu tienda.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: NorlandColors.texto,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Transform.translate(
              offset: const Offset(0, -28),
              child: Icon(
                Icons.location_on_rounded,
                size: 58,
                color: Colors.red,
                shadows: <Shadow>[
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: NorlandColors.blanco.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '© OpenStreetMap',
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(fontSize: 9),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: NorlandColors.blanco,
          border: const Border(top: BorderSide(color: NorlandColors.borde)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: NorlandColors.azulRey.withValues(alpha: 0.08),
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
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.my_location_rounded,
                      size: 17,
                      color: NorlandColors.verde,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        '${_centroActual.latitude.toStringAsFixed(5)}, '
                        '${_centroActual.longitude.toStringAsFixed(5)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: NorlandColors.azulRey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      'Ubicación referencial',
                      style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: NorlandColors.verde,
                      foregroundColor: NorlandColors.blanco,
                    ),
                    onPressed: _confirmar,
                    icon: const Icon(Icons.check_rounded, size: 20),
                    label: const Text('Confirmar ubicación'),
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
