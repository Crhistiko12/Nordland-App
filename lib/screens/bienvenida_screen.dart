import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../widgets/nordland_logo.dart';
import '../widgets/norland_waves.dart';
import 'login_screen.dart';

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  Future<void> _abrirLogin(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NorlandColors.blanco,
      body: Stack(
        children: <Widget>[
          const Positioned(
            top: -130,
            right: -110,
            child: _Halo(size: 300, color: NorlandColors.celesteSuave),
          ),
          const Positioned(
            top: 245,
            left: -140,
            child: _Halo(size: 250, color: NorlandColors.verdeSuave),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 210,
            child: IgnorePointer(child: NorlandWaves()),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double paddingInferior =
                    MediaQuery.paddingOf(context).bottom + 20;

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24, 22, 24, paddingInferior),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 42 - paddingInferior,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 430),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const _SelloOficial(),
                            const SizedBox(height: 26),
                            const _HaloLogo(),
                            const SizedBox(height: 26),
                            Text(
                              'Bienvenido a Nordland,',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'nutrición que te mueve',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: NorlandColors.celeste,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Compra para tu hogar o surte tu negocio con los '
                              'productos oficiales de Nordland.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: NorlandColors.textoSecundario,
                                  ),
                            ),
                            const SizedBox(height: 24),
                            const _Beneficios(),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: () => _abrirLogin(context),
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size.fromHeight(56),
                                  backgroundColor: NorlandColors.azulRey,
                                  foregroundColor: NorlandColors.blanco,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Ingresar / Crear Cuenta'),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded, size: 20),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Tu cuenta te permite comprar, revender y seguir '
                              'tus pedidos en tiempo real.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HaloLogo extends StatelessWidget {
  const _HaloLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 148,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[NorlandColors.blanco, NorlandColors.celesteSuave],
        ),
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: NorlandColors.borde),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NorlandColors.azulRey.withValues(alpha: 0.08),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const NordlandLogo(height: 82, alignment: Alignment.center),
    );
  }
}

class _SelloOficial extends StatelessWidget {
  const _SelloOficial();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: NorlandColors.verdeSuave,
        borderRadius: BorderRadius.circular(NorlandRadius.pill),
        border: Border.all(color: NorlandColors.verde.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.verified_rounded,
            size: 16,
            color: NorlandColors.verde,
          ),
          const SizedBox(width: 6),
          Text(
            'TIENDA OFICIAL',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: NorlandColors.verde,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _Beneficios extends StatelessWidget {
  const _Beneficios();

  @override
  Widget build(BuildContext context) {
    const List<(IconData, String)> items = <(IconData, String)>[
      (Icons.shopping_bag_outlined, 'Compra directa'),
      (Icons.storefront_outlined, 'Precio de revendedor'),
      (Icons.local_shipping_outlined, 'Sigue tu entrega'),
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        for (final (IconData icono, String texto) in items)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
            decoration: BoxDecoration(
              color: NorlandColors.blanco,
              borderRadius: BorderRadius.circular(NorlandRadius.pill),
              border: Border.all(color: NorlandColors.borde),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(icono, size: 15, color: NorlandColors.celeste),
                const SizedBox(width: 5),
                Text(
                  texto,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: NorlandColors.azulRey,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Halo extends StatelessWidget {
  const _Halo({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}
