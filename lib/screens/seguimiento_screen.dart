import 'dart:async';
import 'package:material_ui/material_ui.dart';

import '../services/notificaciones_service.dart';
import '../theme/app_theme.dart';

class SeguimientoScreen extends StatefulWidget {
  const SeguimientoScreen({
    super.key,
    this.duracionInicial = const Duration(hours: 24),
  });

  final Duration duracionInicial;

  @override
  State<SeguimientoScreen> createState() => _SeguimientoScreenState();
}

class _SeguimientoScreenState extends State<SeguimientoScreen> {
  late int _segundosRestantes;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _segundosRestantes = widget.duracionInicial.inSeconds;
    _iniciarCronometro();
  }

  void _iniciarCronometro() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) return;
      if (_segundosRestantes > 0) {
        setState(() {
          _segundosRestantes -= 1;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _tiempoFormateado {
    final int horas = _segundosRestantes ~/ 3600;
    final int minutos = (_segundosRestantes % 3600) ~/ 60;
    final int segundos = _segundosRestantes % 60;

    final String hStr = horas.toString().padLeft(2, '0');
    final String mStr = minutos.toString().padLeft(2, '0');
    final String sStr = segundos.toString().padLeft(2, '0');

    return '$hStr:$mStr:$sStr';
  }

  Future<void> _ejecutarSimulacionCercania() async {
    // 1. Vibración larga
    await NotificacionesService.instance.vibrarAlertaLarga();

    // 2. Notificación local
    await NotificacionesService.instance.mostrarAlertaCercania();

    // 3. AlertDialog en pantalla grande
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NorlandRadius.xl),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Column(
          children: <Widget>[
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: NorlandColors.verdeSuave,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_shipping_rounded,
                color: NorlandColors.verde,
                size: 38,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '¡Pedido a menos de 200m!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: NorlandColors.texto,
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '¡Tu pedido Norland está a menos de 200 metros!\nPrepara la recepción.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: NorlandColors.azulRey,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'El repartidor se encuentra en tu zona y llegará en breves minutos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: NorlandColors.textoSecundario,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: NorlandColors.verde,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(NorlandRadius.md),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '¡Entendido, salgo a recibir!',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NorlandColors.fondo,
      appBar: AppBar(
        backgroundColor: NorlandColors.blanco,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: const Text('Seguimiento del Pedido'),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: SizedBox(
            height: 1,
            child: ColoredBox(color: NorlandColors.borde),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: <Widget>[
              // Estado general
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: NorlandColors.blanco,
                  borderRadius: BorderRadius.circular(NorlandRadius.lg),
                  border: Border.all(color: NorlandColors.borde),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: NorlandColors.azulRey.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: NorlandColors.celesteSuave,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.delivery_dining_rounded,
                            color: NorlandColors.azulRey,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Pedido en camino',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: NorlandColors.azulRey,
                                    ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Preparando tu pedido con productos frescos',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: NorlandColors.textoSecundario,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const _LineasEstado(pasoActivo: 2),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tarjeta del Cronómetro de 24 Horas
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      NorlandColors.azulRey,
                      NorlandColors.celeste,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(NorlandRadius.lg),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: NorlandColors.azulRey.withValues(alpha: 0.25),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.timer_outlined,
                          color: NorlandColors.blanco,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'COMPROMISO DE ENTREGA NORLAND',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: NorlandColors.blanco.withValues(alpha: 0.9),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Llegará en $_tiempoFormateado',
                      style: const TextStyle(
                        color: NorlandColors.blanco,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: NorlandColors.blanco.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(NorlandRadius.pill),
                      ),
                      child: const Text(
                        'Garantía máxima de entrega en 24 horas',
                        style: TextStyle(
                          color: NorlandColors.blanco,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Botón de Simulación de Cercanía (< 200m)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: NorlandColors.verdeSuave,
                  borderRadius: BorderRadius.circular(NorlandRadius.lg),
                  border: Border.all(
                    color: NorlandColors.verde.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Row(
                      children: <Widget>[
                        Icon(
                          Icons.radar_rounded,
                          color: NorlandColors.verde,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'MODO DE PRUEBA (CERCANÍA)',
                          style: TextStyle(
                            color: NorlandColors.verde,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Prueba la alarma sensorial cuando el repartidor se aproxime a menos de 200 metros de tu domicilio.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: NorlandColors.textoSecundario,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 14),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: NorlandColors.verde,
                        foregroundColor: NorlandColors.blanco,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(NorlandRadius.md),
                        ),
                      ),
                      onPressed: _ejecutarSimulacionCercania,
                      icon: const Icon(Icons.notifications_active_rounded, size: 20),
                      label: const Text(
                        'Simular < 200m',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Detalle de la entrega
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: NorlandColors.blanco,
                  borderRadius: BorderRadius.circular(NorlandRadius.lg),
                  border: Border.all(color: NorlandColors.borde),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Información de entrega',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: NorlandColors.texto,
                      ),
                    ),
                    SizedBox(height: 12),
                    _ItemInfo(
                      icono: Icons.place_outlined,
                      titulo: 'Destino',
                      descripcion: 'Dirección seleccionada al momento del pedido',
                    ),
                    SizedBox(height: 10),
                    _ItemInfo(
                      icono: Icons.receipt_long_outlined,
                      titulo: 'Tipo de entrega',
                      descripcion: 'Directo de fábrica Nordland a tu puerta',
                    ),
                    SizedBox(height: 10),
                    _ItemInfo(
                      icono: Icons.shield_outlined,
                      titulo: 'Seguridad',
                      descripcion: 'Cadena de frío y empaque sellado',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).popUntil((Route<dynamic> r) => r.isFirst);
                },
                icon: const Icon(Icons.home_outlined),
                label: const Text('Volver al inicio'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: NorlandColors.borde),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(NorlandRadius.md),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LineasEstado extends StatelessWidget {
  const _LineasEstado({required this.pasoActivo});

  final int pasoActivo;

  @override
  Widget build(BuildContext context) {
    const List<String> pasos = <String>[
      'Confirmado',
      'Preparando',
      'En camino',
      'Entregado',
    ];

    return Row(
      children: <Widget>[
        for (int i = 0; i < pasos.length; i++)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 3,
                        color: i == 0
                            ? Colors.transparent
                            : (i <= pasoActivo
                                ? NorlandColors.azulRey
                                : NorlandColors.borde),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i <= pasoActivo
                            ? NorlandColors.azulRey
                            : NorlandColors.blanco,
                        border: Border.all(
                          color: i <= pasoActivo
                              ? NorlandColors.azulRey
                              : NorlandColors.borde,
                          width: 2,
                        ),
                      ),
                      child: i < pasoActivo
                          ? const Icon(
                              Icons.check,
                              size: 13,
                              color: NorlandColors.blanco,
                            )
                          : (i == pasoActivo
                              ? Center(
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: NorlandColors.blanco,
                                    ),
                                  ),
                                )
                              : null),
                    ),
                    Expanded(
                      child: Container(
                        height: 3,
                        color: i == pasos.length - 1
                            ? Colors.transparent
                            : (i < pasoActivo
                                ? NorlandColors.azulRey
                                : NorlandColors.borde),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  pasos[i],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight:
                        i == pasoActivo ? FontWeight.w800 : FontWeight.w600,
                    color: i <= pasoActivo
                        ? NorlandColors.azulRey
                        : NorlandColors.textoSecundario,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ItemInfo extends StatelessWidget {
  const _ItemInfo({
    required this.icono,
    required this.titulo,
    required this.descripcion,
  });

  final IconData icono;
  final String titulo;
  final String descripcion;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icono, size: 18, color: NorlandColors.azulRey),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: NorlandColors.texto,
                ),
              ),
              Text(
                descripcion,
                style: const TextStyle(
                  fontSize: 12,
                  color: NorlandColors.textoSecundario,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
