import 'package:material_ui/material_ui.dart';

/// Doble onda decorativa inspirada en el logotipo de Nordland.
class NorlandWaves extends StatelessWidget {
  const NorlandWaves({
    super.key,
    this.colorAzul = const Color(0xFF2998D5),
    this.colorVerde = const Color(0xFF58A944),
  });

  final Color colorAzul;
  final Color colorVerde;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _NorlandWavesPainter(
        colorAzul: colorAzul,
        colorVerde: colorVerde,
      ),
      size: Size.infinite,
    );
  }
}

class _NorlandWavesPainter extends CustomPainter {
  const _NorlandWavesPainter({
    required this.colorAzul,
    required this.colorVerde,
  });

  final Color colorAzul;
  final Color colorVerde;

  @override
  void paint(Canvas canvas, Size size) {
    final Path azul = Path()
      ..moveTo(0, size.height * 0.42)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.12,
        size.width * 0.48,
        size.height * 0.2,
        size.width * 0.64,
        size.height * 0.45,
      )
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.68,
        size.width * 0.9,
        size.height * 0.7,
        size.width,
        size.height * 0.52,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final Path verde = Path()
      ..moveTo(0, size.height * 0.68)
      ..cubicTo(
        size.width * 0.26,
        size.height * 0.38,
        size.width * 0.52,
        size.height * 0.48,
        size.width * 0.7,
        size.height * 0.72,
      )
      ..cubicTo(
        size.width * 0.82,
        size.height * 0.87,
        size.width * 0.94,
        size.height * 0.85,
        size.width,
        size.height * 0.76,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(azul, Paint()..color = colorAzul.withValues(alpha: 0.2));
    canvas.drawPath(verde, Paint()..color = colorVerde.withValues(alpha: 0.22));
  }

  @override
  bool shouldRepaint(covariant _NorlandWavesPainter oldDelegate) =>
      oldDelegate.colorAzul != colorAzul ||
      oldDelegate.colorVerde != colorVerde;
}
