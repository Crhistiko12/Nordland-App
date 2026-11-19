import 'package:material_ui/material_ui.dart';

/// Logotipo oficial de Nordland.
///
/// El manual de marca indica que la versión principal a color debe utilizarse
/// preferentemente sobre fondos blancos.
class NordlandLogo extends StatelessWidget {
  const NordlandLogo({
    super.key,
    this.height = 40,
    this.alignment = Alignment.centerLeft,
  });

  final double height;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/nordland_logo.png',
      height: height,
      fit: BoxFit.contain,
      alignment: alignment,
      filterQuality: FilterQuality.medium,
      semanticLabel: 'Nordland, nutrición que te mueve',
    );
  }
}
