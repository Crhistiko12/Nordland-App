import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../screens/carrito_screen.dart';
import '../screens/registro_tienda_screen.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';

/// Accesos rápidos para registrar una tienda oficial y abrir el carrito.
///
/// Se usa tanto en la pantalla de inicio como en el menú lateral para que el
/// flujo de "Tienda Oficial" y el carrito estén siempre a un toque.
class AccionesTiendaCarrito extends StatelessWidget {
  const AccionesTiendaCarrito({super.key, this.compacto = false});

  /// Reduce textos y espaciados para encajar en el [Drawer].
  final bool compacto;

  void _abrir(BuildContext context, Widget pantalla) {
    final NavigatorState navigator = Navigator.of(context);
    final ScaffoldState? scaffold = Scaffold.maybeOf(context);
    if (scaffold != null && scaffold.isDrawerOpen) {
      navigator.pop();
    }
    navigator.push(
      MaterialPageRoute<void>(builder: (BuildContext context) => pantalla),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartService>(
      builder: (BuildContext context, CartService cart, Widget? child) {
        final int cantidad = cart.cantidadTotal;
        final String productos = cantidad == 1 ? 'producto' : 'productos';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _BotonAccion(
              color: NorlandColors.azulRey,
              icono: const Icon(
                Icons.storefront_rounded,
                color: NorlandColors.blanco,
                size: 21,
              ),
              etiqueta: 'Quiero ser Tienda Oficial',
              detalle: compacto
                  ? null
                  : 'Registra tu negocio con ubicación y foto',
              onTap: () => _abrir(context, const RegistroTiendaScreen()),
            ),
            const SizedBox(height: 10),
            _BotonAccion(
              color: NorlandColors.verde,
              icono: Badge(
                isLabelVisible: cantidad > 0,
                backgroundColor: NorlandColors.rojo,
                textColor: NorlandColors.blanco,
                label: Text(
                  cantidad > 99 ? '99+' : '$cantidad',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: NorlandColors.blanco,
                  size: 21,
                ),
              ),
              etiqueta: 'Ver mi Carrito ($cantidad $productos)',
              detalle: compacto
                  ? null
                  : 'Revisa tus productos y confirma tu pedido',
              onTap: () => _abrir(context, const CarritoScreen()),
            ),
          ],
        );
      },
    );
  }
}

class _BotonAccion extends StatelessWidget {
  const _BotonAccion({
    required this.color,
    required this.icono,
    required this.etiqueta,
    required this.detalle,
    required this.onTap,
  });

  final Color color;
  final Widget icono;
  final String etiqueta;
  final String? detalle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(NorlandRadius.md),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: detalle == null ? 12 : 13,
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: NorlandColors.blanco.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: icono,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      etiqueta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: NorlandColors.blanco,
                        fontSize: detalle == null ? 14 : 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (detalle != null) ...<Widget>[
                      const SizedBox(height: 2),
                      Text(
                        detalle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: NorlandColors.blanco.withValues(alpha: 0.85),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right_rounded,
                color: NorlandColors.blanco.withValues(alpha: 0.85),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
