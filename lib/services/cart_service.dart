import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../models/producto.dart';

class CartItem {
  CartItem({required this.producto, this.cantidad = 1});

  final Producto producto;
  int cantidad;

  double get subtotal => producto.precio * cantidad;
}

class CartService extends ChangeNotifier {
  final Map<String, CartItem> _items = <String, CartItem>{};

  List<CartItem> get items => _items.values.toList(growable: false);

  int get itemTipoCount => _items.length;

  bool get estaVacio => _items.isEmpty;

  int get cantidadTotal =>
      _items.values.fold<int>(0, (int total, CartItem item) => total + item.cantidad);

  double get total =>
      _items.values.fold<double>(0.0, (double suma, CartItem item) => suma + item.subtotal);

  int cantidadDe(String productoId) => _items[productoId]?.cantidad ?? 0;

  void agregar(Producto producto, {int cantidad = 1}) {
    if (cantidad <= 0) return;

    if (_items.containsKey(producto.id)) {
      _items[producto.id]!.cantidad += cantidad;
    } else {
      _items[producto.id] = CartItem(
        producto: producto,
        cantidad: cantidad,
      );
    }
    notifyListeners();
  }

  void decrementar(String productoId) {
    if (!_items.containsKey(productoId)) return;

    final CartItem item = _items[productoId]!;
    if (item.cantidad > 1) {
      item.cantidad -= 1;
    } else {
      _items.remove(productoId);
    }
    notifyListeners();
  }

  void incrementar(String productoId) {
    if (!_items.containsKey(productoId)) return;
    _items[productoId]!.cantidad += 1;
    notifyListeners();
  }

  void remover(String productoId) {
    if (_items.remove(productoId) != null) {
      notifyListeners();
    }
  }

  void vaciar() {
    if (_items.isNotEmpty) {
      _items.clear();
      notifyListeners();
    }
  }

  static CartService of(BuildContext context, {bool listen = true}) {
    return Provider.of<CartService>(context, listen: listen);
  }
}
