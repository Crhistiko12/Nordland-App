import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../models/producto.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';
import '../utils/formato_moneda.dart';
import '../widgets/boton_carrito_badge.dart';
import '../widgets/imagen_catalogo.dart';
import 'carrito_screen.dart';

class DetalleProductoScreen extends StatelessWidget {
  const DetalleProductoScreen({super.key, required this.producto});

  final Producto producto;

  void _agregarAlCarrito(BuildContext context) {
    final CartService? cart = Provider.of<CartService?>(context, listen: false);
    cart?.agregar(producto);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Se agregó "${producto.nombre}" al carrito.'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VER CARRITO',
          textColor: NorlandColors.celeste,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const CarritoScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NorlandColors.blanco,
      appBar: AppBar(
        backgroundColor: NorlandColors.blanco,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(
          'Detalle del producto',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: const <Widget>[
          BotonCarritoBadge(),
          SizedBox(width: 4),
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
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.35,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(NorlandRadius.xl),
                    border: Border.all(color: NorlandColors.borde),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Hero(
                        tag: 'producto-${producto.id}',
                        child: ImagenCatalogo(
                          categoria: producto.categoria,
                          asset: producto.imagen,
                          iconSize: 54,
                          fit: BoxFit.contain,
                        ),
                      ),
                      if (producto.etiqueta != null)
                        Positioned(
                          top: 14,
                          left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: NorlandColors.blanco.withValues(
                                alpha: 0.94,
                              ),
                              borderRadius: BorderRadius.circular(
                                NorlandRadius.pill,
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: NorlandColors.azulRey.withValues(
                                    alpha: 0.08,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              producto.etiqueta!,
                              style: TextStyle(
                                color: producto.categoria.color,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: producto.categoria.colorSuave,
                      borderRadius: BorderRadius.circular(NorlandRadius.pill),
                    ),
                    child: Text(
                      producto.categoria.etiqueta.toUpperCase(),
                      style: TextStyle(
                        color: producto.categoria.color,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                producto.nombre,
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(fontSize: 27),
              ),
              const SizedBox(height: 4),
              Text(
                producto.presentacion,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: NorlandColors.textoSecundario),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    formatearPrecio(producto.precio),
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(color: NorlandColors.azulRey),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        'precio unitario',
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: NorlandColors.textoSecundario),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: NorlandColors.verdeSuave,
                  borderRadius: BorderRadius.circular(NorlandRadius.md),
                  border: Border.all(
                    color: NorlandColors.verde.withValues(alpha: 0.16),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: NorlandColors.blanco,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.storefront_rounded,
                        color: NorlandColors.verde,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Precio de revendedor',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: NorlandColors.verde,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${formatearPrecio(producto.precioMayorista)} '
                            'desde 12 unidades',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: NorlandColors.verde),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Sobre este producto',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 7),
              Text(
                producto.descripcion,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.55,
                  color: NorlandColors.textoSecundario,
                ),
              ),
              const SizedBox(height: 22),
              const _PuntoBeneficio(
                icono: Icons.verified_rounded,
                texto: 'Producto oficial Nordland',
              ),
              const SizedBox(height: 10),
              const _PuntoBeneficio(
                icono: Icons.local_shipping_outlined,
                texto: 'Compra directa y seguimiento de tu pedido',
              ),
              const SizedBox(height: 10),
              const _PuntoBeneficio(
                icono: Icons.savings_outlined,
                texto: 'Precio especial al comprar por volumen',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: NorlandColors.blanco,
          border: Border(top: BorderSide(color: NorlandColors.borde)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: NorlandColors.sombra,
              blurRadius: 18,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
            child: Align(
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Row(
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Precio',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: NorlandColors.textoSecundario),
                        ),
                        Text(
                          formatearPrecio(producto.precio),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _agregarAlCarrito(context),
                        icon: const Icon(
                          Icons.add_shopping_cart_rounded,
                          size: 18,
                        ),
                        label: const Text('Agregar al carrito'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PuntoBeneficio extends StatelessWidget {
  const _PuntoBeneficio({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icono, color: NorlandColors.celeste, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            texto,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: NorlandColors.textoSecundario),
          ),
        ),
      ],
    );
  }
}
