import '../models/cart_item.dart';
import '../models/menu_item.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  static const double deliveryFee = 800;
  static const double serviceFee = 200;

  factory CartService() => _instance;

  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(MenuItem menuItem) {
    final index = _items.indexWhere((item) => item.menuItem.id == menuItem.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(menuItem: menuItem));
    }
  }

  void removeItem(String menuItemId) {
    _items.removeWhere((item) => item.menuItem.id == menuItemId);
  }

  void clear() {
    _items.clear();
  }

  void increaseQty(String menuItemId) {
    final item = _items.firstWhere((item) => item.menuItem.id == menuItemId);
    item.quantity++;
  }

  void decreaseQty(String menuItemId) {
    final index = _items.indexWhere((item) => item.menuItem.id == menuItemId);

    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
    }
  }

  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get total => subtotal + deliveryFee + serviceFee;
}
