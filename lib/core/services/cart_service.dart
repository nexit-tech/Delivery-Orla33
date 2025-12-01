import 'package:flutter/material.dart';
import '../models/cart_item.dart'; // <--- O IMPORT QUE FALTAVA

class CartService extends ChangeNotifier {
  static final CartService instance = CartService._();
  CartService._();

  final List<CartItem> _items = [];
  List<CartItem> get items => _items;

  double get subtotal => _items.fold(0, (total, item) => total + item.total);
  double get deliveryFee => 12.00; 
  double get total => subtotal + deliveryFee;

  void addToCart(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}