import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../widgets/norland_waves.dart';
import 'selector_ubicacion_screen.dart';

/// Formulario para que las tiendas se postulen como puntos de venta oficiales.
class RegistroPuntoVentaScreen extends StatefulWidget {
  const RegistroPuntoVentaScreen({super.key});

  @override
  State<RegistroPuntoVentaScreen> createState() =>
      _RegistroPuntoVentaScreenState();
}

class _RegistroPuntoVentaScreenState extends State<RegistroPuntoVentaScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreTienda = TextEditingController();
  final TextEditingController _nombreDueno = TextEditingController();
  final TextEditingController _telefono = TextEditingController();
  final TextEditingController _direccion = TextEditingController();

  LatLng? _ubicacion;
  bool _ubicacionInvalida = false;

  @override
  void dispose() {
    _nombreTienda.dispose();
    _nombreDueno.dispose();
    _telefono.dispose();
    _direccion.dispose();
    super.dispose();
  }

  Future<void> _seleccionarUbicacion() async {
    final LatLng? ubicacion = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute<LatLng>(
        builder: (BuildContext context) =>
            SelectorUbicacionScreen(ubicacionInicial: _ubicacion),
      ),
    );

    if (ubicacion == null || !mounted) return;
    setState(() {
      _ubicacion = ubicacion;
      _ubicacionInvalida = false;
    });
  }

  void _enviarSolicitud() {
    FocusScope.of(context).unfocus();

    final bool formularioValido = _formKey.currentState?.validate() ?? false;
    final bool ubicacionValida = _ubicacion != null;

    if (!ubicacionValida) {
      setState(() => _ubicacionInvalida = true);
    }

    if (!formularioValido || !ubicacionValida) {
      if (!ubicacionValida) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              backgroundColor: NorlandColors.naranja,
              content: Text(
                'Selecciona la ubicación de tu tienda para continuar.',
              ),
            ),
          );
      }
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: NorlandColors.verde,
          duration: const Duration(seconds: 6),
          content: Row(
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: NorlandColors.blanco.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 18,
                  color: NorlandColors.blanco,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  '¡Solicitud enviada! Nordland se contactará contigo para '
                  'oficializar tu punto de venta.',
                ),
              ),
            ],
          ),
        ),
      );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NorlandColors.blanco,
      appBar: AppBar(title: const Text('Quiero ser Punto de Venta')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 26),
          children: <Widget>[
            const _CabeceraRegistro(),
            const SizedBox(height: 22),
            Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: NorlandColors.verdeSuave,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    size: 17,
                    color: NorlandColors.verde,
                  ),
                ),
                const SizedBox(width: 9),
                Text(
                  'Datos del negocio',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nombreTienda,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nombre de la tienda',
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
              controller: _nombreDueno,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nombre del dueño',
                hintText: 'Nombre y apellido',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (String? valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Ingresa el nombre del dueño.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _telefono,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
              ],
              decoration: const InputDecoration(
                labelText: 'Teléfono',
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
            const SizedBox(height: 12),
            TextFormField(
              controller: _direccion,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Dirección',
                hintText: 'Calle, número y zona',
                prefixIcon: Icon(Icons.home_work_outlined),
              ),
              validator: (String? valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Ingresa la dirección de tu tienda.';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            Text(
              'Ubicación en el mapa',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            _SelectorUbicacion(
              ubicacion: _ubicacion,
              conError: _ubicacionInvalida,
              onTap: _seleccionarUbicacion,
            ),
            const SizedBox(height: 22),
            const _BeneficiosRegistro(),
            const SizedBox(height: 16),
            Text(
              'Al enviar tu solicitud aceptas que un asesor de Nordland te '
              'contacte por teléfono o WhatsApp. La verificación del punto de '
              'venta es gratuita.',
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
                  backgroundColor: NorlandColors.verde,
                  foregroundColor: NorlandColors.blanco,
                ),
                onPressed: _enviarSolicitud,
                icon: const Icon(Icons.send_rounded, size: 19),
                label: const Text('Enviar solicitud'),
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
                      color: NorlandColors.verde,
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
                    'Haz crecer tu negocio con Nordland',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Súmate al directorio oficial de puntos de venta y ofrece '
                    'la nutrición que te mueve a tu comunidad.',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: NorlandColors.textoSecundario),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const <Widget>[
                      _Sello(texto: 'Sin costo'),
                      _Sello(texto: 'Asesoría Nordland'),
                      _Sello(texto: 'Productos oficiales'),
                    ],
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

class _Sello extends StatelessWidget {
  const _Sello({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: NorlandColors.blanco,
        borderRadius: BorderRadius.circular(NorlandRadius.pill),
        border: Border.all(color: NorlandColors.verde.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.check_circle_rounded,
            size: 13,
            color: NorlandColors.verde,
          ),
          const SizedBox(width: 4),
          Text(
            texto,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: NorlandColors.azulRey,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectorUbicacion extends StatelessWidget {
  const _SelectorUbicacion({
    required this.ubicacion,
    required this.conError,
    required this.onTap,
  });

  final LatLng? ubicacion;
  final bool conError;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool seleccionada = ubicacion != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(NorlandRadius.lg),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: seleccionada
                    ? NorlandColors.verdeSuave
                    : NorlandColors.fondo,
                borderRadius: BorderRadius.circular(NorlandRadius.lg),
                border: Border.all(
                  color: conError
                      ? NorlandColors.naranja
                      : seleccionada
                      ? NorlandColors.verde
                      : NorlandColors.borde,
                  width: conError || seleccionada ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: seleccionada
                          ? NorlandColors.verde
                          : NorlandColors.blanco,
                      borderRadius: BorderRadius.circular(13),
                      border: seleccionada
                          ? null
                          : Border.all(color: NorlandColors.borde),
                    ),
                    child: Icon(
                      seleccionada
                          ? Icons.check_rounded
                          : Icons.add_location_alt_rounded,
                      color: seleccionada
                          ? NorlandColors.blanco
                          : NorlandColors.verde,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          seleccionada
                              ? 'Ubicación seleccionada'
                              : 'Seleccionar ubicación en el mapa',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: seleccionada
                                    ? NorlandColors.verde
                                    : NorlandColors.azulRey,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          seleccionada
                              ? '${ubicacion!.latitude.toStringAsFixed(5)}, '
                                    '${ubicacion!.longitude.toStringAsFixed(5)} · '
                                    'Toca para cambiar'
                              : 'Marca el lugar exacto de tu tienda.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: NorlandColors.textoSecundario,
                    size: 20,
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
              'Selecciona la ubicación de tu tienda.',
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: NorlandColors.naranja, fontSize: 11),
            ),
          ),
      ],
    );
  }
}

class _BeneficiosRegistro extends StatelessWidget {
  const _BeneficiosRegistro();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: NorlandColors.celesteSuave,
        borderRadius: BorderRadius.circular(NorlandRadius.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.support_agent_rounded,
            color: NorlandColors.celeste,
            size: 22,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'Nuestro equipo revisará tu solicitud en 24 a 48 horas y te '
              'acompañará en todo el proceso para oficializar tu punto de '
              'venta.',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: NorlandColors.azulRey, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}
