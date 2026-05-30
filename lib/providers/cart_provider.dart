import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';

class CartProvider extends ChangeNotifier {
  static const double deliveryFee = 800;
  static const double serviceFee = 200;

  final List<CartItem> _items = [];
  String? _vendorId;
  String? _vendorName;

  List<CartItem> get items => _items;
  String? get vendorId => _vendorId;
  String? get vendorName => _vendorName;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;

  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get total => subtotal + deliveryFee + serviceFee;

  void addItem(MenuItem menuItem, {String? vendorId, String? vendorName}) {
    // If adding from a different vendor, clear cart first
    if (_vendorId != null && vendorId != null && _vendorId != vendorId) {
      _items.clear();
    }

    _vendorId = vendorId;
    _vendorName = vendorName;

    final index = _items.indexWhere((item) => item.menuItem.id == menuItem.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(menuItem: menuItem));
    }

    notifyListeners();
  }

  void removeItem(String menuItemId) {
    _items.removeWhere((item) => item.menuItem.id == menuItemId);
    if (_items.isEmpty) {
      _vendorId = null;
      _vendorName = null;
    }
    notifyListeners();
  }

  void increaseQty(String menuItemId) {
    final index = _items.indexWhere((item) => item.menuItem.id == menuItemId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQty(String menuItemId) {
    final index = _items.indexWhere((item) => item.menuItem.id == menuItemId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      if (_items.isEmpty) {
        _vendorId = null;
        _vendorName = null;
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    _vendorId = null;
    _vendorName = null;
    notifyListeners();
  }
}
