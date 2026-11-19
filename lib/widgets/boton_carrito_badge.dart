import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../screens/carrito_screen.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';

class BotonCarritoBadge extends StatelessWidget {
  const BotonCarritoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final CartService? cart = Provider.of<CartService?>(context);
    final int cantidad = cart?.cantidadTotal ?? 0;

    return IconButton(
      tooltip: 'Carrito de compras',
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const CarritoScreen(),
          ),
        );
      },
      icon: Badge(
        isLabelVisible: cantidad > 0,
        backgroundColor: NorlandColors.rojo,
        textColor: NorlandColors.blanco,
        label: Text(
          cantidad > 99 ? '99+' : '$cantidad',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
        child: const Icon(Icons.shopping_bag_outlined),
      ),
    );
  }
}
