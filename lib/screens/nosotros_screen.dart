import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../widgets/boton_carrito_badge.dart';
import '../widgets/navegacion_nordland.dart';
import '../widgets/qr_nordland_dialog.dart';

class NosotrosScreen extends StatelessWidget {
  const NosotrosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NorlandColors.fondo,
      appBar: NorlandAppBar(
        seccionActual: SeccionNordland.nosotros,
        acciones: <Widget>[
          IconButton(
            tooltip: 'Código QR',
            onPressed: () => mostrarQrNordland(context),
            icon: const Icon(Icons.qr_code_2_rounded),
          ),
          const BotonCarritoBadge(),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
            children: const <Widget>[
              _HeroNosotros(),
              SizedBox(height: 24),
              _HistoriaNosotros(),
              SizedBox(height: 24),
              _MisionVision(),
              SizedBox(height: 24),
              _TarjetaQr(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroNosotros extends StatelessWidget {
  const _HeroNosotros();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(NorlandRadius.xl),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[NorlandColors.azulRey, NorlandColors.celeste],
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -70,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: NorlandColors.blanco.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: 120,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: NorlandColors.blanco.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(26),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool ancho = constraints.maxWidth >= 640;

                final Widget texto = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: NorlandColors.blanco.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(NorlandRadius.pill),
                      ),
                      child: const Text(
                        'NUESTRA ESENCIA',
                        style: TextStyle(
                          color: NorlandColors.blanco,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Nutrición que te mueve',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(color: NorlandColors.blanco),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Somos una marca boliviana que acerca alimentos y bebidas '
                      'de origen vegetal a los hogares y negocios del país.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: NorlandColors.blanco.withValues(alpha: 0.92),
                      ),
                    ),
                  ],
                );

                if (!ancho) return texto;

                return Row(
                  children: <Widget>[
                    Expanded(child: texto),
                    const SizedBox(width: 28),
                    Container(
                      width: 122,
                      height: 122,
                      decoration: BoxDecoration(
                        color: NorlandColors.blanco.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.eco_rounded,
                        size: 58,
                        color: NorlandColors.blanco,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoriaNosotros extends StatelessWidget {
  const _HistoriaNosotros();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: NorlandColors.blanco,
        borderRadius: BorderRadius.circular(NorlandRadius.lg),
        border: Border.all(color: NorlandColors.borde),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _EncabezadoSeccion(
            sobrelinea: 'NUESTRA HISTORIA',
            titulo: 'De Bolivia para tu mesa',
            icono: Icons.storefront_rounded,
          ),
          const SizedBox(height: 16),
          Text(
            'Nordland nació en Bolivia con una idea sencilla: demostrar que la '
            'nutrición de origen vegetal puede ser rica, accesible y parte de la '
            'vida diaria. Empezamos con recetas a base de soya y frutas, '
            'elaboradas con cuidado para que cada familia encuentre una opción '
            'confiable en su mesa.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          Text(
            'Hoy llevamos agua, helados, leches y yogurts a hogares y negocios, '
            'y trabajamos junto a una red de puntos de venta para estar cada vez '
            'más cerca de ti.',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: NorlandColors.textoSecundario),
          ),
          const SizedBox(height: 18),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _Detalle(texto: 'Origen vegetal'),
              _Detalle(texto: 'Calidad boliviana'),
              _Detalle(texto: 'Cerca de ti'),
            ],
          ),
        ],
      ),
    );
  }
}

class _EncabezadoSeccion extends StatelessWidget {
  const _EncabezadoSeccion({
    required this.sobrelinea,
    required this.titulo,
    required this.icono,
  });

  final String sobrelinea;
  final String titulo;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: NorlandColors.verdeSuave,
            shape: BoxShape.circle,
          ),
          child: Icon(icono, color: NorlandColors.verde, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                sobrelinea,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: NorlandColors.verde,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 3),
              Text(titulo, style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _Detalle extends StatelessWidget {
  const _Detalle({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: NorlandColors.verdeSuave,
        borderRadius: BorderRadius.circular(NorlandRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.check_circle_rounded,
            color: NorlandColors.verde,
            size: 15,
          ),
          const SizedBox(width: 6),
          Text(
            texto,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: NorlandColors.verde,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MisionVision extends StatelessWidget {
  const _MisionVision();

  @override
  Widget build(BuildContext context) {
    const Widget mision = _TarjetaValor(
      icono: Icons.flag_rounded,
      etiqueta: 'MISIÓN',
      titulo: 'Nutrición cercana',
      texto:
          'Acercar a cada hogar y negocio de Bolivia alimentos y bebidas de '
          'origen vegetal, accesibles, deliciosos y nutritivos, con una red de '
          'distribución cercana y confiable.',
      color: NorlandColors.azulRey,
      fondoIcono: NorlandColors.celesteSuave,
    );
    const Widget vision = _TarjetaValor(
      icono: Icons.visibility_rounded,
      etiqueta: 'VISIÓN',
      titulo: 'Una marca que acompaña',
      texto:
          'Ser la marca boliviana de referencia en alimentación vegetal, '
          'reconocida por su calidad, su innovación y por acompañar el '
          'bienestar de las familias y los emprendedores.',
      color: NorlandColors.verde,
      fondoIcono: NorlandColors.verdeSuave,
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 720) {
          return const Column(
            children: <Widget>[mision, SizedBox(height: 14), vision],
          );
        }

        return const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: mision),
            SizedBox(width: 14),
            Expanded(child: vision),
          ],
        );
      },
    );
  }
}

class _TarjetaValor extends StatelessWidget {
  const _TarjetaValor({
    required this.icono,
    required this.etiqueta,
    required this.titulo,
    required this.texto,
    required this.color,
    required this.fondoIcono,
  });

  final IconData icono;
  final String etiqueta;
  final String titulo;
  final String texto;
  final Color color;
  final Color fondoIcono;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: NorlandColors.blanco,
        borderRadius: BorderRadius.circular(NorlandRadius.lg),
        border: Border.all(color: NorlandColors.borde),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: fondoIcono,
              shape: BoxShape.circle,
            ),
            child: Icon(icono, color: color, size: 23),
          ),
          const SizedBox(height: 14),
          Text(
            etiqueta,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 3),
          Text(titulo, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            texto,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: NorlandColors.textoSecundario),
          ),
        ],
      ),
    );
  }
}

class _TarjetaQr extends StatelessWidget {
  const _TarjetaQr();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: NorlandColors.blanco,
        borderRadius: BorderRadius.circular(NorlandRadius.lg),
        border: Border.all(color: NorlandColors.borde),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool ancho = constraints.maxWidth >= 620;

          final Widget qr = Container(
            width: 96,
            height: 96,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: NorlandColors.blanco,
              borderRadius: BorderRadius.circular(NorlandRadius.sm),
              border: Border.all(color: NorlandColors.borde),
            ),
            child: Image.asset(
              'assets/images/qr_nordland.png',
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
              semanticLabel: 'Código QR de Nordland',
            ),
          );

          final Widget texto = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Lleva Nordland contigo',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 5),
              Text(
                'Escanea el código QR para descargar la app móvil y comprar '
                'desde donde estés.',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: NorlandColors.textoSecundario),
              ),
            ],
          );

          final Widget boton = FilledButton.icon(
            onPressed: () => mostrarQrNordland(context),
            style: FilledButton.styleFrom(
              backgroundColor: NorlandColors.verde,
              foregroundColor: NorlandColors.blanco,
            ),
            icon: const Icon(Icons.qr_code_2_rounded, size: 20),
            label: const Text('Ver código QR'),
          );

          if (!ancho) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Align(alignment: Alignment.centerLeft, child: qr),
                const SizedBox(height: 14),
                texto,
                const SizedBox(height: 14),
                boton,
              ],
            );
          }

          return Row(
            children: <Widget>[
              qr,
              const SizedBox(width: 18),
              Expanded(child: texto),
              const SizedBox(width: 18),
              boton,
            ],
          );
        },
      ),
    );
  }
}
