import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

/// Pin rojo personalizado para los puntos de venta del mapa.
class PinPuntoVenta extends StatelessWidget {
  const PinPuntoVenta({
    super.key,
    required this.nombre,
    required this.onTap,
    this.seleccionado = false,
  });

  final String nombre;
  final VoidCallback onTap;
  final bool seleccionado;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Punto de venta $nombre',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedScale(
          scale: seleccionado ? 1.16 : 1,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          child: SizedBox(
            width: 56,
            height: 62,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: NorlandColors.blanco,
                          width: 3,
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.24),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.storefront_rounded,
                        size: 22,
                        color: NorlandColors.blanco,
                      ),
                    ),
                    CustomPaint(
                      size: const Size(16, 12),
                      painter: _ColaPinPainter(),
                    ),
                  ],
                ),
                if (seleccionado)
                  Positioned(
                    top: -5,
                    right: 2,
                    child: Container(
                      width: 21,
                      height: 21,
                      decoration: BoxDecoration(
                        color: NorlandColors.amarillo,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: NorlandColors.blanco,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.star_rounded,
                        size: 13,
                        color: NorlandColors.blanco,
                      ),
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

class _ColaPinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Path cola = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(
      cola,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
