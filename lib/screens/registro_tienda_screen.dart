import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/tienda_registrada.dart';
import '../services/database_helper.dart';
import '../theme/app_theme.dart';
import '../widgets/norland_waves.dart';

/// Formulario para que los dueños de negocios registren su Tienda Oficial.
///
/// Los datos se guardan en la base de datos local SQLite junto con las
/// coordenadas del mapa y la ruta de la foto de la fachada.
class RegistroTiendaScreen extends StatefulWidget {
  const RegistroTiendaScreen({super.key});

  @override
  State<RegistroTiendaScreen> createState() => _RegistroTiendaScreenState();
}

class _RegistroTiendaScreenState extends State<RegistroTiendaScreen> {
  static const LatLng _ubicacionInicial = LatLng(-17.3895, -66.1568);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MapController _mapController = MapController();
  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController _nombreTienda = TextEditingController();
  final TextEditingController _propietario = TextEditingController();
  final TextEditingController _telefono = TextEditingController();

  LatLng _ubicacion = _ubicacionInicial;
  Uint8List? _fotoBytes;
  String? _fotoRuta;
  bool _fotoInvalida = false;
  bool _guardando = false;
  bool _mapaListo = false;

  @override
  void dispose() {
    _nombreTienda.dispose();
    _propietario.dispose();
    _telefono.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _moverPin(DragUpdateDetails details) {
    if (!_mapaListo) return;

    final MapCamera camara = _mapController.camera;
    final Offset posicionActual = camara.latLngToScreenOffset(_ubicacion);
    final LatLng nuevaUbicacion = camara.screenOffsetToLatLng(
      posicionActual + details.delta,
    );

    setState(() => _ubicacion = nuevaUbicacion);
  }

  Future<void> _mostrarOpcionesFoto() async {
    final ImageSource? fuente = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Text(
                  'Foto de la fachada',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_camera_outlined,
                  color: NorlandColors.azulRey,
                ),
                title: const Text('Tomar una foto'),
                subtitle: const Text('Usa la cámara de tu dispositivo'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: NorlandColors.verde,
                ),
                title: const Text('Elegir de la galería'),
                subtitle: const Text('Selecciona una imagen existente'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (fuente == null) return;
    await _seleccionarFoto(fuente);
  }

  Future<void> _seleccionarFoto(ImageSource fuente) async {
    try {
      final bool esMovil =
          !kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS);

      if (fuente == ImageSource.camera && esMovil) {
        final PermissionStatus permiso = await Permission.camera.request();
        if (!mounted) return;
        if (!permiso.isGranted) {
          _mostrarMensaje(
            'Necesitamos permiso de cámara para tomar la foto de tu tienda.',
            color: NorlandColors.naranja,
          );
          return;
        }
      }

      final XFile? archivo = await _imagePicker.pickImage(
        source: fuente,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (archivo == null) return;

      final Uint8List bytes = await archivo.readAsBytes();
      if (!mounted) return;

      setState(() {
        _fotoBytes = bytes;
        _fotoRuta = archivo.path;
        _fotoInvalida = false;
      });
    } catch (_) {
      if (!mounted) return;
      _mostrarMensaje(
        'No se pudo obtener la foto. Revisa los permisos de cámara.',
        color: NorlandColors.rojo,
      );
    }
  }

  void _quitarFoto() {
    setState(() {
      _fotoBytes = null;
      _fotoRuta = null;
      _fotoInvalida = true;
    });
  }

  void _mostrarMensaje(String mensaje, {Color? color}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(backgroundColor: color, content: Text(mensaje)));
  }

  Future<void> _guardarTienda() async {
    FocusScope.of(context).unfocus();

    final bool formularioValido = _formKey.currentState?.validate() ?? false;
    final bool fotoValida = _fotoRuta != null;

    if (!fotoValida) {
      setState(() => _fotoInvalida = true);
    }

    if (!formularioValido || !fotoValida) {
      _mostrarMensaje(
        fotoValida
            ? 'Completa todos los datos de tu tienda.'
            : 'Agrega una foto de la fachada de tu tienda.',
        color: NorlandColors.naranja,
      );
      return;
    }

    setState(() => _guardando = true);

    try {
      await DatabaseHelper.instance.guardarTienda(
        TiendaRegistrada(
          nombreTienda: _nombreTienda.text.trim(),
          propietario: _propietario.text.trim(),
          telefono: _telefono.text.trim(),
          latitud: _ubicacion.latitude,
          longitud: _ubicacion.longitude,
          fotoFachada: _fotoRuta,
          creadoEn: DateTime.now(),
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: NorlandColors.verde,
            duration: const Duration(seconds: 5),
            content: Row(
              children: <Widget>[
                const Icon(
                  Icons.check_circle_rounded,
                  color: NorlandColors.blanco,
                  size: 20,
                ),
                const SizedBox(width: 9),
                const Expanded(
                  child: Text(
                    '¡Tienda registrada! Norland se contactará contigo',
                  ),
                ),
              ],
            ),
          ),
        );

      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _guardando = false);
      _mostrarMensaje(
        'No se pudo guardar la tienda. Inténtalo nuevamente.',
        color: NorlandColors.rojo,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NorlandColors.blanco,
      appBar: AppBar(title: const Text('Tienda Oficial')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          children: <Widget>[
            const _CabeceraRegistro(),
            const SizedBox(height: 22),
            const _TituloSeccion(
              icono: Icons.storefront_rounded,
              color: NorlandColors.verde,
              fondo: NorlandColors.verdeSuave,
              titulo: 'Datos del negocio',
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nombreTienda,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nombre de la tienda / negocio',
                hintText: 'Ej. Minimarket Doña Elvira',
                prefixIcon: Icon(Icons.storefront_outlined),
              ),
              validator: (String? valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Ingresa el nombre de tu tienda.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _propietario,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nombre del propietario',
                hintText: 'Nombre y apellido',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (String? valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Ingresa el nombre del propietario.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _telefono,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
              ],
              decoration: const InputDecoration(
                labelText: 'Teléfono de contacto',
                hintText: 'Ej. 712 345 67',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (String? valor) {
                final String digitos = (valor ?? '').replaceAll(
                  RegExp(r'[^0-9]'),
                  '',
                );
                if (digitos.length < 7) {
                  return 'Ingresa un teléfono válido.';
                }
                return null;
              },
            ),
            const SizedBox(height: 22),
            const _TituloSeccion(
              icono: Icons.map_rounded,
              color: NorlandColors.celeste,
              fondo: NorlandColors.celesteSuave,
              titulo: 'Ubicación en el mapa',
            ),
            const SizedBox(height: 10),
            _MapaTienda(
              ubicacion: _ubicacion,
              onMapReady: () => _mapaListo = true,
              onTapMapa: (LatLng punto) => setState(() => _ubicacion = punto),
              onArrastrarPin: _moverPin,
              mapController: _mapController,
            ),
            const SizedBox(height: 22),
            const _TituloSeccion(
              icono: Icons.photo_camera_rounded,
              color: NorlandColors.naranja,
              fondo: NorlandColors.naranjaSuave,
              titulo: 'Foto de la fachada',
            ),
            const SizedBox(height: 10),
            _FotoFachada(
              bytes: _fotoBytes,
              conError: _fotoInvalida,
              onSeleccionar: _mostrarOpcionesFoto,
              onQuitar: _quitarFoto,
            ),
            const SizedBox(height: 20),
            Text(
              'Al registrar tu tienda aceptas que un asesor de Nordland te '
              'contacte para verificar tu negocio y oficializarlo como Tienda '
              'Oficial. El registro no tiene costo.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(fontSize: 10.5, height: 1.45),
            ),
          ],
        ),
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
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: NorlandColors.azulRey,
                  foregroundColor: NorlandColors.blanco,
                ),
                onPressed: _guardando ? null : _guardarTienda,
                icon: _guardando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: NorlandColors.blanco,
                        ),
                      )
                    : const Icon(Icons.save_rounded, size: 19),
                label: Text(_guardando ? 'Guardando...' : 'Guardar Tienda'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CabeceraRegistro extends StatelessWidget {
  const _CabeceraRegistro();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(NorlandRadius.xl),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFFEFF8EA), Color(0xFFE9F6FC)],
          ),
        ),
        child: Stack(
          children: <Widget>[
            const Positioned.fill(
              child: IgnorePointer(
                child: NorlandWaves(
                  colorAzul: NorlandColors.celeste,
                  colorVerde: NorlandColors.verde,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: NorlandColors.azulRey,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: NorlandColors.blanco,
                      size: 27,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Registra tu Tienda Oficial',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Suma tu negocio a la red Nordland. Marca tu ubicación en '
                    'el mapa y muéstranos la fachada de tu tienda.',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: NorlandColors.textoSecundario),
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

class _TituloSeccion extends StatelessWidget {
  const _TituloSeccion({
    required this.icono,
    required this.color,
    required this.fondo,
    required this.titulo,
  });

  final IconData icono;
  final Color color;
  final Color fondo;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: fondo,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icono, size: 17, color: color),
        ),
        const SizedBox(width: 9),
        Text(titulo, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}

class _MapaTienda extends StatelessWidget {
  const _MapaTienda({
    required this.ubicacion,
    required this.onMapReady,
    required this.onTapMapa,
    required this.onArrastrarPin,
    required this.mapController,
  });

  final LatLng ubicacion;
  final VoidCallback onMapReady;
  final ValueChanged<LatLng> onTapMapa;
  final GestureDragUpdateCallback onArrastrarPin;
  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(NorlandRadius.lg),
      child: Container(
        height: 270,
        decoration: BoxDecoration(
          border: Border.all(color: NorlandColors.borde),
        ),
        child: Stack(
          children: <Widget>[
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: ubicacion,
                initialZoom: 15,
                minZoom: 4,
                maxZoom: 18,
                backgroundColor: NorlandColors.fondo,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
                onMapReady: onMapReady,
                onTap: (_, LatLng punto) => onTapMapa(punto),
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
                      point: ubicacion,
                      width: 60,
                      height: 60,
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanUpdate: onArrastrarPin,
                        child: Icon(
                          Icons.location_on_rounded,
                          size: 52,
                          color: NorlandColors.rojo,
                          shadows: <Shadow>[
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: NorlandColors.blanco.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(NorlandRadius.sm),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: NorlandColors.azulRey.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.touch_app_rounded,
                      size: 17,
                      color: NorlandColors.celeste,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Arrastra el pin o toca el mapa para marcar tu tienda.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: NorlandColors.texto,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: NorlandColors.blanco.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.my_location_rounded,
                      size: 13,
                      color: NorlandColors.verde,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${ubicacion.latitude.toStringAsFixed(5)}, '
                      '${ubicacion.longitude.toStringAsFixed(5)}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: NorlandColors.azulRey,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
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
      ),
    );
  }
}

class _FotoFachada extends StatelessWidget {
  const _FotoFachada({
    required this.bytes,
    required this.conError,
    required this.onSeleccionar,
    required this.onQuitar,
  });

  final Uint8List? bytes;
  final bool conError;
  final VoidCallback onSeleccionar;
  final VoidCallback onQuitar;

  @override
  Widget build(BuildContext context) {
    if (bytes == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onSeleccionar,
              borderRadius: BorderRadius.circular(NorlandRadius.lg),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 26,
                  horizontal: 18,
                ),
                decoration: BoxDecoration(
                  color: NorlandColors.fondo,
                  borderRadius: BorderRadius.circular(NorlandRadius.lg),
                  border: Border.all(
                    color: conError
                        ? NorlandColors.naranja
                        : NorlandColors.borde,
                    width: conError ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: NorlandColors.naranjaSuave,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_a_photo_rounded,
                        color: NorlandColors.naranja,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sube una foto de la fachada',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Puedes tomarla con la cámara o elegirla de tu galería.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (conError)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text(
                'Agrega una foto de la fachada de tu tienda.',
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(color: NorlandColors.naranja, fontSize: 11),
              ),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(NorlandRadius.lg),
          child: Stack(
            children: <Widget>[
              Image.memory(
                bytes!,
                width: double.infinity,
                height: 190,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Material(
                  color: NorlandColors.blanco.withValues(alpha: 0.92),
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: 'Quitar foto',
                    onPressed: onQuitar,
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 19,
                      color: NorlandColors.rojo,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 18, 12, 9),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.55),
                      ],
                    ),
                  ),
                  child: const Row(
                    children: <Widget>[
                      Icon(
                        Icons.check_circle_rounded,
                        size: 15,
                        color: NorlandColors.blanco,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Foto de la fachada lista',
                        style: TextStyle(
                          color: NorlandColors.blanco,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onSeleccionar,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Cambiar foto'),
        ),
      ],
    );
  }
}
