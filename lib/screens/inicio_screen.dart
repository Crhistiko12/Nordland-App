import 'package:material_ui/material_ui.dart';

import '../models/producto.dart';
import '../services/auth_service.dart';
import '../services/catalogo_service.dart';
import '../theme/app_theme.dart';
import '../widgets/boton_carrito_badge.dart';
import '../widgets/categoria_card.dart';
import '../widgets/nordland_logo.dart';
import '../widgets/producto_card.dart';
import 'detalle_producto_screen.dart';
import 'mapa_puntos_venta_screen.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  final TextEditingController _buscadorController = TextEditingController();
  CategoriaProducto? _categoriaActiva;
  String _consulta = '';

  @override
  void dispose() {
    _buscadorController.dispose();
    super.dispose();
  }

  String get _nombre {
    final usuario = AuthService.instance.usuarioActual;
    final String nombre = usuario?.displayName?.trim() ?? '';
    if (nombre.isNotEmpty) {
      return _capitalizar(nombre.split(RegExp(r'\s+')).first);
    }

    final String correo = usuario?.email ?? '';
    if (correo.contains('@')) {
      return _capitalizar(correo.split('@').first);
    }
    return 'bienvenido';
  }

  String get _correo =>
      AuthService.instance.usuarioActual?.email ?? 'Cuenta Nordland';

  String _capitalizar(String texto) {
    final String limpio = texto.trim();
    if (limpio.isEmpty) return 'bienvenido';
    return '${limpio[0].toUpperCase()}${limpio.substring(1)}';
  }

  void _cambiarCategoria(CategoriaProducto categoria) {
    setState(() {
      _categoriaActiva = _categoriaActiva == categoria ? null : categoria;
    });
  }

  void _limpiarFiltros() {
    _buscadorController.clear();
    setState(() {
      _consulta = '';
      _categoriaActiva = null;
    });
  }

  void _abrirMapa() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const MapaPuntosVentaScreen(),
      ),
    );
  }

  void _abrirDetalle(Producto producto) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            DetalleProductoScreen(producto: producto),
      ),
    );
  }

  Future<void> _cerrarSesion() async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('¿Cerrar sesión?'),
        content: const Text(
          'Podrás volver a ingresar con tu correo o con Google.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await AuthService.instance.cerrarSesion();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Producto> productos = CatalogoService.filtrar(
      categoria: _categoriaActiva,
      texto: _consulta,
    );
    final bool filtrosActivos =
        _categoriaActiva != null || _consulta.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: NorlandColors.fondo,
      appBar: AppBar(
        backgroundColor: NorlandColors.blanco,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: const NordlandLogo(height: 27),
        titleSpacing: 16,
        actions: <Widget>[
          IconButton(
            tooltip: 'Puntos de venta',
            onPressed: _abrirMapa,
            icon: const Icon(Icons.location_on_outlined),
          ),
          const BotonCarritoBadge(),
          _MenuCuenta(
            nombre: _nombre,
            correo: _correo,
            onCerrarSesion: _cerrarSesion,
          ),
          const SizedBox(width: 6),
        ],
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
          constraints: const BoxConstraints(maxWidth: 1100),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _Saludo(nombre: _nombre),
                      const SizedBox(height: 16),
                      _Buscador(
                        controller: _buscadorController,
                        consulta: _consulta,
                        onChanged: (String valor) {
                          setState(() => _consulta = valor);
                        },
                        onLimpiar: _limpiarFiltros,
                      ),
                      const SizedBox(height: 18),
                      _BannerPuntos(onTap: _abrirMapa),
                      const SizedBox(height: 24),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Categorías',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          if (filtrosActivos)
                            TextButton(
                              onPressed: _limpiarFiltros,
                              child: const Text('Ver todo'),
                            )
                          else
                            Text(
                              '4 categorías',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: NorlandColors.textoSecundario,
                                  ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 132,
                        child: Row(
                          children: <Widget>[
                            for (
                              int index = 0;
                              index < CatalogoService.categorias.length;
                              index++
                            ) ...<Widget>[
                              if (index > 0) const SizedBox(width: 8),
                              Expanded(
                                child: CategoriaCard(
                                  categoria: CatalogoService.categorias[index],
                                  seleccionada:
                                      _categoriaActiva ==
                                      CatalogoService.categorias[index],
                                  onTap: () => _cambiarCategoria(
                                    CatalogoService.categorias[index],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              filtrosActivos
                                  ? 'Resultados'
                                  : 'Los favoritos de Nordland',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          Text(
                            '${productos.length} '
                            '${productos.length == 1 ? 'producto' : 'productos'}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: NorlandColors.textoSecundario,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              if (productos.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: _SinResultados(onLimpiar: _limpiarFiltros),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 230,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          mainAxisExtent: 292,
                        ),
                    delegate: SliverChildBuilderDelegate((
                      BuildContext context,
                      int index,
                    ) {
                      final Producto producto = productos[index];
                      return ProductoCard(
                        producto: producto,
                        onTap: () => _abrirDetalle(producto),
                      );
                    }, childCount: productos.length),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Saludo extends StatelessWidget {
  const _Saludo({required this.nombre});

  final String nombre;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Hola, $nombre',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 3),
              Text(
                'Encuentra tus favoritos Nordland para tu hogar o negocio.',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: NorlandColors.textoSecundario),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            color: NorlandColors.verdeSuave,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.shopping_basket_rounded,
            color: NorlandColors.verde,
            size: 23,
          ),
        ),
      ],
    );
  }
}

class _Buscador extends StatelessWidget {
  const _Buscador({
    required this.controller,
    required this.consulta,
    required this.onChanged,
    required this.onLimpiar,
  });

  final TextEditingController controller;
  final String consulta;
  final ValueChanged<String> onChanged;
  final VoidCallback onLimpiar;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: 'Busca agua, helados, leches o yogurts',
        hintStyle: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: NorlandColors.textoSecundario),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: NorlandColors.azulRey,
          size: 21,
        ),
        suffixIcon: consulta.isNotEmpty
            ? IconButton(
                tooltip: 'Limpiar búsqueda',
                onPressed: onLimpiar,
                icon: const Icon(Icons.close_rounded, size: 19),
              )
            : null,
        filled: true,
        fillColor: NorlandColors.blanco,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NorlandRadius.md),
          borderSide: const BorderSide(color: NorlandColors.borde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NorlandRadius.md),
          borderSide: const BorderSide(color: NorlandColors.borde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NorlandRadius.md),
          borderSide: const BorderSide(
            color: NorlandColors.celeste,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

class _BannerPuntos extends StatelessWidget {
  const _BannerPuntos({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(NorlandRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(NorlandRadius.lg),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[NorlandColors.azulRey, NorlandColors.celeste],
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -46,
                right: -30,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: NorlandColors.blanco.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -36,
                right: 74,
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: NorlandColors.blanco.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(17),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: NorlandColors.blanco.withValues(
                                alpha: 0.16,
                              ),
                              borderRadius: BorderRadius.circular(
                                NorlandRadius.pill,
                              ),
                            ),
                            child: const Text(
                              'TIENDA OFICIAL',
                              style: TextStyle(
                                color: NorlandColors.blanco,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Compra cerca de ti',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(color: NorlandColors.blanco),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Encuentra el punto de venta Nordland más cercano.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: NorlandColors.blanco.withValues(
                                    alpha: 0.9,
                                  ),
                                ),
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            children: <Widget>[
                              Icon(
                                Icons.map_outlined,
                                color: NorlandColors.blanco,
                                size: 15,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Ver mapa',
                                style: TextStyle(
                                  color: NorlandColors.blanco,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: NorlandColors.blanco.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.storefront_rounded,
                        color: NorlandColors.blanco,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCuenta extends StatelessWidget {
  const _MenuCuenta({
    required this.nombre,
    required this.correo,
    required this.onCerrarSesion,
  });

  final String nombre;
  final String correo;
  final VoidCallback onCerrarSesion;

  @override
  Widget build(BuildContext context) {
    final String inicial = nombre.isEmpty
        ? 'N'
        : nombre.substring(0, 1).toUpperCase();

    return PopupMenuButton<String>(
      tooltip: 'Mi cuenta',
      onSelected: (String valor) {
        if (valor == 'salir') onCerrarSesion();
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                nombre,
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(color: NorlandColors.texto),
              ),
              const SizedBox(height: 2),
              Text(
                correo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: NorlandColors.textoSecundario),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'salir',
          child: Row(
            children: <Widget>[
              Icon(
                Icons.logout_rounded,
                size: 18,
                color: NorlandColors.textoSecundario,
              ),
              SizedBox(width: 8),
              Text('Cerrar sesión'),
            ],
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: NorlandColors.azulRey,
          child: Text(
            inicial,
            style: const TextStyle(
              color: NorlandColors.blanco,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _SinResultados extends StatelessWidget {
  const _SinResultados({required this.onLimpiar});

  final VoidCallback onLimpiar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: NorlandColors.blanco,
        borderRadius: BorderRadius.circular(NorlandRadius.lg),
        border: Border.all(color: NorlandColors.borde),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: NorlandColors.celesteSuave,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              color: NorlandColors.azulRey,
              size: 26,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No encontramos productos',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Prueba con otra categoría o revisa la ortografía de tu búsqueda.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: NorlandColors.textoSecundario),
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: onLimpiar,
            child: const Text('Limpiar filtros'),
          ),
        ],
      ),
    );
  }
}
