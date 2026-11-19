import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';

import '../screens/galeria_screen.dart';
import '../screens/nosotros_screen.dart';
import '../theme/app_theme.dart';
import 'nordland_logo.dart';
import 'qr_nordland_dialog.dart';

/// Secciones principales de la experiencia web de Nordland.
enum SeccionNordland {
  inicio(
    etiqueta: 'Inicio',
    icono: Icons.home_outlined,
    iconoActivo: Icons.home_rounded,
  ),
  nosotros(
    etiqueta: 'Nosotros',
    icono: Icons.info_outline_rounded,
    iconoActivo: Icons.info_rounded,
  ),
  galeria(
    etiqueta: 'Galería',
    icono: Icons.photo_library_outlined,
    iconoActivo: Icons.photo_library_rounded,
  );

  const SeccionNordland({
    required this.etiqueta,
    required this.icono,
    required this.iconoActivo,
  });

  final String etiqueta;
  final IconData icono;
  final IconData iconoActivo;
}

const double anchoNavegacionWeb = 840;

bool mostrarNavegacionWeb(BuildContext context) {
  return kIsWeb && MediaQuery.sizeOf(context).width >= anchoNavegacionWeb;
}

Route<void>? _rutaDeSeccion(SeccionNordland seccion) {
  switch (seccion) {
    case SeccionNordland.inicio:
      return null;
    case SeccionNordland.nosotros:
      return MaterialPageRoute<void>(
        builder: (BuildContext context) => const NosotrosScreen(),
      );
    case SeccionNordland.galeria:
      return MaterialPageRoute<void>(
        builder: (BuildContext context) => const GaleriaScreen(),
      );
  }
}

void irASeccion(NavigatorState navigator, SeccionNordland seccion) {
  if (seccion == SeccionNordland.inicio) {
    navigator.popUntil((Route<dynamic> route) => route.isFirst);
    return;
  }

  final Route<void>? ruta = _rutaDeSeccion(seccion);
  if (ruta == null) return;

  if (navigator.canPop()) {
    navigator.pushReplacement(ruta);
  } else {
    navigator.push(ruta);
  }
}

void abrirSeccion(BuildContext context, SeccionNordland seccion) {
  irASeccion(Navigator.of(context), seccion);
}

/// Botones de navegación que se muestran directamente en el AppBar web.
class NavegacionNordland extends StatelessWidget {
  const NavegacionNordland({super.key, required this.seccionActual});

  final SeccionNordland seccionActual;

  @override
  Widget build(BuildContext context) {
    if (!mostrarNavegacionWeb(context)) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final SeccionNordland seccion in SeccionNordland.values)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: _BotonSeccion(
              seccion: seccion,
              activa: seccion == seccionActual,
              onTap: seccion == seccionActual
                  ? null
                  : () => abrirSeccion(context, seccion),
            ),
          ),
      ],
    );
  }
}

class _BotonSeccion extends StatelessWidget {
  const _BotonSeccion({
    required this.seccion,
    required this.activa,
    required this.onTap,
  });

  final SeccionNordland seccion;
  final bool activa;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = activa
        ? NorlandColors.azulRey
        : NorlandColors.textoSecundario;

    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: color,
        backgroundColor: activa
            ? NorlandColors.celesteSuave
            : Colors.transparent,
        minimumSize: const Size(0, 38),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NorlandRadius.sm),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            activa ? seccion.iconoActivo : seccion.icono,
            size: 17,
            color: activa ? NorlandColors.verde : color,
          ),
          const SizedBox(width: 6),
          Text(
            seccion.etiqueta,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: activa ? FontWeight.w800 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// AppBar compartida por las secciones principales.
///
/// En web muestra los accesos directos y el botón de volver cuando hay una
/// pantalla apilada. En móvil usa el [Drawer] de la sección de inicio.
class NorlandAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NorlandAppBar({
    super.key,
    required this.seccionActual,
    this.acciones = const <Widget>[],
    this.conDrawer = false,
  });

  final SeccionNordland seccionActual;
  final List<Widget> acciones;
  final bool conDrawer;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final bool puedeVolver = Navigator.canPop(context);

    Widget? leading;
    if (kIsWeb && puedeVolver) {
      leading = IconButton(
        tooltip: 'Volver',
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back),
      );
    } else if (conDrawer && !mostrarNavegacionWeb(context)) {
      leading = Builder(
        builder: (BuildContext context) => IconButton(
          tooltip: 'Abrir menú',
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: const Icon(Icons.menu_rounded),
        ),
      );
    } else if (!kIsWeb && puedeVolver) {
      leading = IconButton(
        tooltip: 'Volver',
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back),
      );
    }

    return AppBar(
      backgroundColor: NorlandColors.blanco,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leading: leading,
      titleSpacing: leading == null ? 16 : 0,
      title: const NordlandLogo(height: 27),
      actions: <Widget>[
        NavegacionNordland(seccionActual: seccionActual),
        ...acciones,
        const SizedBox(width: 6),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: SizedBox(
          height: 1,
          child: ColoredBox(color: NorlandColors.borde),
        ),
      ),
    );
  }
}

/// Menú lateral para pantallas móviles.
class NordlandDrawer extends StatelessWidget {
  const NordlandDrawer({super.key, required this.seccionActual});

  final SeccionNordland seccionActual;

  void _navegar(BuildContext context, SeccionNordland seccion) {
    final NavigatorState navigator = Navigator.of(context);
    navigator.pop();
    if (seccion != seccionActual) {
      irASeccion(navigator, seccion);
    }
  }

  void _abrirQr(BuildContext context) {
    final BuildContext screenContext =
        Scaffold.maybeOf(context)?.context ?? context;
    Navigator.of(context).pop();
    mostrarQrNordland(screenContext);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: NorlandColors.blanco,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(NorlandRadius.xl),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 22, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  NordlandLogo(height: 30),
                  SizedBox(height: 6),
                  Text(
                    'Nutrición que te mueve',
                    style: TextStyle(
                      color: NorlandColors.textoSecundario,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: <Widget>[
                  for (final SeccionNordland seccion in SeccionNordland.values)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: ListTile(
                        leading: Icon(
                          seccion == seccionActual
                              ? seccion.iconoActivo
                              : seccion.icono,
                          color: seccion == seccionActual
                              ? NorlandColors.verde
                              : NorlandColors.textoSecundario,
                        ),
                        title: Text(
                          seccion.etiqueta,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: seccion == seccionActual
                                    ? NorlandColors.azulRey
                                    : NorlandColors.texto,
                              ),
                        ),
                        selected: seccion == seccionActual,
                        selectedTileColor: NorlandColors.celesteSuave,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(NorlandRadius.sm),
                        ),
                        onTap: () => _navegar(context, seccion),
                      ),
                    ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: NorlandColors.verdeSuave,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.qr_code_2_rounded,
                        size: 19,
                        color: NorlandColors.verde,
                      ),
                    ),
                    title: Text(
                      'Código QR',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    subtitle: Text(
                      'Descarga la app móvil',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(NorlandRadius.sm),
                    ),
                    onTap: () => _abrirQr(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
              child: Text(
                'Nordland · Bolivia',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
