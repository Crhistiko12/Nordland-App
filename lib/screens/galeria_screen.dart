import 'package:material_ui/material_ui.dart';

import '../models/producto.dart';
import '../services/catalogo_service.dart';
import '../theme/app_theme.dart';
import '../widgets/boton_carrito_badge.dart';
import '../widgets/imagen_catalogo.dart';
import '../widgets/navegacion_nordland.dart';
import 'detalle_producto_screen.dart';

class GaleriaScreen extends StatelessWidget {
  const GaleriaScreen({super.key});

  void _abrirDetalle(BuildContext context, Producto producto) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            DetalleProductoScreen(producto: producto),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Producto> productos = CatalogoService.productos;

    return Scaffold(
      backgroundColor: NorlandColors.fondo,
      appBar: const NorlandAppBar(
        seccionActual: SeccionNordland.galeria,
        acciones: <Widget>[BotonCarritoBadge()],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: NorlandColors.verdeSuave,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.photo_library_rounded,
                              color: NorlandColors.verde,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Galería Nordland',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Conoce de cerca nuestros productos y descubre el color '
                        'de la nutrición que te mueve.',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: NorlandColors.textoSecundario),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: NorlandColors.blanco,
                          borderRadius: BorderRadius.circular(
                            NorlandRadius.pill,
                          ),
                          border: Border.all(color: NorlandColors.borde),
                        ),
                        child: Text(
                          '${productos.length} imágenes de productos',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: NorlandColors.azulRey,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 240,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    mainAxisExtent: 300,
                  ),
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int index,
                  ) {
                    final Producto producto = productos[index];
                    return _TarjetaGaleria(
                      producto: producto,
                      onTap: () => _abrirDetalle(context, producto),
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

class _TarjetaGaleria extends StatelessWidget {
  const _TarjetaGaleria({required this.producto, required this.onTap});

  final Producto producto;
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
            color: NorlandColors.blanco,
            borderRadius: BorderRadius.circular(NorlandRadius.lg),
            border: Border.all(color: NorlandColors.borde),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ImagenCatalogo(
                      categoria: producto.categoria,
                      asset: producto.imagen,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: NorlandColors.blanco.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(
                            NorlandRadius.pill,
                          ),
                        ),
                        child: Text(
                          producto.categoria.etiqueta.toUpperCase(),
                          style: TextStyle(
                            color: producto.categoria.color,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      producto.nombre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      producto.presentacion,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
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
