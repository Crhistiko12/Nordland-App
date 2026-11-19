import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../services/cart_service.dart';
import '../theme/app_theme.dart';
import '../utils/formato_moneda.dart';
import '../widgets/imagen_catalogo.dart';
import 'seguimiento_screen.dart';

class CarritoScreen extends StatelessWidget {
  const CarritoScreen({super.key});

  void _confirmarPedido(BuildContext context, CartService cart) {
    cart.vaciar();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const SeguimientoScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartService>(
      builder: (BuildContext context, CartService cart, Widget? child) {
        final bool vacio = cart.estaVacio;

        return Scaffold(
          backgroundColor: NorlandColors.fondo,
          appBar: AppBar(
            backgroundColor: NorlandColors.blanco,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            title: const Text('Mi Carrito'),
            centerTitle: true,
            actions: <Widget>[
              if (!vacio)
                IconButton(
                  tooltip: 'Vaciar carrito',
                  onPressed: () async {
                    final bool? confirmar = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('¿Vaciar carrito?'),
                        content: const Text(
                          'Se eliminarán todos los productos agregados.',
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancelar'),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: NorlandColors.rojo,
                            ),
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Vaciar'),
                          ),
                        ],
                      ),
                    );
                    if (confirmar == true) {
                      cart.vaciar();
                    }
                  },
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
              const SizedBox(width: 4),
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: SizedBox(
                height: 1,
                child: ColoredBox(color: NorlandColors.borde),
              ),
            ),
          ),
          body: vacio
              ? const _CarritoVacio()
              : Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
                      itemCount: cart.items.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (BuildContext context, int index) {
                        final CartItem item = cart.items[index];
                        return _ItemCarritoCard(item: item, cart: cart);
                      },
                    ),
                  ),
                ),
          bottomNavigationBar: vacio
              ? null
              : _BarraInferiorTotal(
                  cart: cart,
                  onConfirmar: () => _confirmarPedido(context, cart),
                ),
        );
      },
    );
  }
}

class _ItemCarritoCard extends StatelessWidget {
  const _ItemCarritoCard({required this.item, required this.cart});

  final CartItem item;
  final CartService cart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: NorlandColors.blanco,
        borderRadius: BorderRadius.circular(NorlandRadius.lg),
        border: Border.all(color: NorlandColors.borde),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NorlandColors.azulRey.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Imagen del producto
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(NorlandRadius.md),
              color: NorlandColors.fondo,
              border: Border.all(color: NorlandColors.borde),
            ),
            clipBehavior: Clip.antiAlias,
            child: ImagenCatalogo(
              categoria: item.producto.categoria,
              asset: item.producto.imagen,
              iconSize: 26,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),

          // Información del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  item.producto.nombre,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: NorlandColors.texto,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.producto.presentacion,
                  style: const TextStyle(
                    fontSize: 12,
                    color: NorlandColors.textoSecundario,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text(
                      formatearPrecio(item.subtotal),
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: NorlandColors.azulRey,
                      ),
                    ),
                    Text(
                      '(${formatearPrecio(item.producto.precio)} c/u)',
                      style: const TextStyle(
                        fontSize: 11,
                        color: NorlandColors.textoSecundario,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Controles de cantidad
          Container(
            decoration: BoxDecoration(
              color: NorlandColors.fondo,
              borderRadius: BorderRadius.circular(NorlandRadius.md),
              border: Border.all(color: NorlandColors.borde),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  onTap: () => cart.decrementar(item.producto.id),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(NorlandRadius.md),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    child: Icon(
                      item.cantidad == 1
                          ? Icons.delete_outline_rounded
                          : Icons.remove_rounded,
                      size: 16,
                      color: item.cantidad == 1
                          ? NorlandColors.rojo
                          : NorlandColors.azulRey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '${item.cantidad}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: NorlandColors.texto,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => cart.incrementar(item.producto.id),
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(NorlandRadius.md),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                    child: Icon(
                      Icons.add_rounded,
                      size: 16,
                      color: NorlandColors.azulRey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BarraInferiorTotal extends StatelessWidget {
  const _BarraInferiorTotal({
    required this.cart,
    required this.onConfirmar,
  });

  final CartService cart;
  final VoidCallback onConfirmar;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
          child: Align(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Total (${cart.cantidadTotal} ${cart.cantidadTotal == 1 ? 'producto' : 'productos'}):',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: NorlandColors.textoSecundario,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatearPrecio(cart.total),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: NorlandColors.azulRey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: NorlandColors.azulRey,
                        foregroundColor: NorlandColors.blanco,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(NorlandRadius.md),
                        ),
                      ),
                      onPressed: onConfirmar,
                      icon: const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 20,
                      ),
                      label: const Text(
                        'Confirmar Pedido',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CarritoVacio extends StatelessWidget {
  const _CarritoVacio();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: NorlandColors.celesteSuave,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 46,
                color: NorlandColors.azulRey,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tu carrito está vacío',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: NorlandColors.texto,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aún no has agregado productos.\nExplora nuestro catálogo y llévate lo mejor de Nordland.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: NorlandColors.textoSecundario,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: NorlandColors.azulRey,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(NorlandRadius.md),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.storefront_rounded),
              label: const Text(
                'Explorar catálogo',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
